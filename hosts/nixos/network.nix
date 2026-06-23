{pkgs, ...}: {
  # ╔═══════════════════════════════════════════════════════════════╗
  # ║  LAYER 1: FIREWALL                                            ║
  # ╚═══════════════════════════════════════════════════════════════╝

  networking = {
    hostName = "nixos";

    networkmanager = {
      enable = true;
      dns = "none"; # We manage DNS ourselves
    };

    nameservers = ["127.0.0.1" "::1"];

    firewall = {
      enable = true;
      allowedTCPPorts = [2017]; # v2rayA web UI
      trustedInterfaces = ["tun0" "tun1"]; # Transparent proxy
      checkReversePath = false; # Required for VPN/tproxy return traffic
    };
  };

  # ╔═══════════════════════════════════════════════════════════════╗
  # ║  LAYER 2: ENCRYPTED DNS (dnscrypt-proxy)                      ║
  # ╚═══════════════════════════════════════════════════════════════╝

  services.resolved.enable = false;

  services.dnscrypt-proxy = {
    enable = true;
    settings = {
      listen_addresses = ["127.0.0.1:53" "[::1]:53"];

      # ── Bootstrap: plain DNS used ONLY to download the server list.
      # Breaks the chicken-and-egg problem (system DNS points to
      # 127.0.0.1 but dnscrypt isn't ready yet on first boot).
      bootstrap_resolvers = ["9.9.9.11:53" "8.8.8.8:53"];
      ignore_system_dns = true;

      # Wait up to 60s for network before giving up
      netprobe_timeout = 60;
      netprobe_address = "9.9.9.9:53";

      # ── Preferred servers (fast, privacy-respecting) ──
      server_names = [
        "cloudflare"
        "cloudflare-ipv6"
        "google"
        "quad9-dnscrypt-ip4-nofilter-pri"
      ];

      # ── Protocol settings ──
      doh_servers = true;
      dnscrypt_servers = true;
      require_dnssec = false; # Some servers don't support it
      require_nolog = true; # Only use servers that don't log
      require_nofilter = true; # No censorship from the DNS side

      # ── Response cache ──
      cache = true;
      cache_size = 4096;
      cache_min_ttl = 2400;
      cache_max_ttl = 86400;

      # ── IPv6: off to avoid leaking queries ──
      ipv6_servers = false;
      block_ipv6 = true;

      # ── Block garbage queries ──
      block_unqualified = true;
      block_undelegated = true;

      # ── Logging ──
      log_level = 2;
      use_syslog = true;

      # ── Server list source (auto-updated) ──
      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };
    };
  };

  # ╔═══════════════════════════════════════════════════════════════╗
  # ║  LAYER 3: PROXY CLIENT — v2rayA                               ║
  # ║                                                               ║
  # ║  Web UI: http://localhost:2017                                ║
  # ║  Modes:                                                       ║
  # ║    - System Proxy: Only apps that support proxy               ║
  # ║    - Transparent Proxy (tproxy): ALL system traffic           ║
  # ╚═══════════════════════════════════════════════════════════════╝

  services.v2raya.enable = true;

  # ╔═══════════════════════════════════════════════════════════════╗
  # ║  LAYER 4: ANTI-DPI (Zapret)                                   ║
  # ║                                                               ║
  # ║  Params tuned for Iranian ISPs. If not working, run:          ║
  # ║  nix-shell -p zapret --command "sudo blockcheck"              ║
  # ║  (with proxy enabled) to find better params.                  ║
  # ╚═══════════════════════════════════════════════════════════════╝

  services.zapret = {
    enable = true;

    # Whitelist: sites that should NOT be processed (local/Iranian sites)
    whitelist = [
      "digikala.com"
      "shaparak.ir"
      "snapp.ir"
      "divar.ir"
      "aparat.com"
    ];

    # Best strategies from blockcheck for your ISP
    params = [
      # ══════════════════════════════════════════════
      # HTTPS/TLS (port 443) — main traffic
      # Strategy: multidisorder at midsld position
      # ══════════════════════════════════════════════
      "--filter-tcp=443"
      "--dpi-desync=multidisorder"
      "--dpi-desync-split-pos=midsld"
      "--dpi-desync-ttl=1"
      "--dpi-desync-fooling=md5sig"
      "--new"

      # ══════════════════════════════════════════════
      # HTTP (port 80) — legacy but still used
      # Strategy: multisplit
      # ══════════════════════════════════════════════
      "--filter-tcp=80"
      "--dpi-desync=multisplit"
      "--dpi-desync-split-pos=method+2,midsld"
    ];
  };

  # ╔═══════════════════════════════════════════════════════════════╗
  # ║  LAYER 5: BACKUP TOOLS                                        ║
  # ║  TODO                                                         ║
  # ╚═══════════════════════════════════════════════════════════════╝

  # ╔═══════════════════════════════════════════════════════════════╗
  # ║  PACKAGES                                                     ║
  # ╚═══════════════════════════════════════════════════════════════╝

  environment.systemPackages = with pkgs; [
    dig
    doggo
    curl
    wget
    httpie
  ];
}
