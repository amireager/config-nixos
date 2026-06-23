{pkgs, ...}: {
  # ╔═══════════════════════════════════════════════════════════════╗
  # ║  LAYER 1: FIREWALL                                            ║
  # ╚═══════════════════════════════════════════════════════════════╝

  networking = {
    hostName = "nixos";

    networkmanager = {
      enable = true;
      dns = "none";
    };

    nameservers = ["127.0.0.1" "::1"];

    firewall = {
      enable = true;
      trustedInterfaces = ["tun0" "tun1" "CloudflareWARP"];
      checkReversePath = false;
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

      bootstrap_resolvers = ["9.9.9.11:53" "8.8.8.8:53"];
      ignore_system_dns = true;
      netprobe_timeout = 60;
      netprobe_address = "9.9.9.9:53";

      server_names = [
        "cloudflare"
        "cloudflare-ipv6"
        "google"
        "quad9-dnscrypt-ip4-nofilter-pri"
      ];

      doh_servers = true;
      dnscrypt_servers = true;
      require_dnssec = false;
      require_nolog = true;
      require_nofilter = true;

      cache = true;
      cache_size = 4096;
      cache_min_ttl = 2400;
      cache_max_ttl = 86400;

      ipv6_servers = false;
      block_ipv6 = true;
      block_unqualified = true;
      block_undelegated = true;

      log_level = 2;
      use_syslog = true;

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
  # ║  LAYER 3: ANTI-DPI (Zapret)                                   ║
  # ║                                                               ║
  # ║  Bypasses DPI-based filtering (YouTube, Twitter, etc).        ║
  # ║  Does NOT help with IP-blocked sites (Instagram, Telegram).   ║
  # ║                                                               ║
  # ║  To find params for your ISP:                                 ║
  # ║    sudo systemctl stop zapret                                 ║
  # ║    nix-shell -p zapret --command "sudo blockcheck"            ║
  # ╚═══════════════════════════════════════════════════════════════╝

  services.zapret = {
    enable = true;

    whitelist = [
      "digikala.com"
      "shaparak.ir"
      "snapp.ir"
      "divar.ir"
      "aparat.com"
    ];

    params = [
      # HTTPS (443) — multidisorder + smart TTL
      "--filter-tcp=443"
      "--dpi-desync=multidisorder"
      "--dpi-desync-split-pos=midsld"
      "--dpi-desync-ttl=1"
      "--dpi-desync-autottl=2"
      "--dpi-desync-fooling=md5sig"
      "--dpi-desync-cutoff=d4"
      "--new"

      # HTTP (80) — multisplit
      "--filter-tcp=80"
      "--dpi-desync=multisplit"
      "--dpi-desync-split-pos=method+2,midsld"
      "--dpi-desync-cutoff=d4"
    ];
  };

  # ╔═══════════════════════════════════════════════════════════════╗
  # ║  LAYER 4: WARP (Cloudflare) — for IP-blocked sites            ║
  # ║                                                               ║
  # ║  Free VPN for sites blocked by IP (Instagram, Telegram, etc)  ║
  # ║                                                               ║
  # ║  Usage:                                                       ║
  # ║    warp-cli registration new         # First time only        ║
  # ║    warp-cli mode proxy               # SOCKS5 on :40000       ║
  # ║    warp-cli connect                  # Connect                ║
  # ║    warp-cli disconnect               # Disconnect             ║
  # ║    warp-cli status                   # Check status           ║
  # ║                                                               ║
  # ║  If connection fails, try different endpoint:                 ║
  # ║    warp-cli tunnel endpoint set 188.114.98.224:891            ║
  # ║    warp-cli tunnel endpoint set 162.159.195.1:2408            ║
  # ╚═══════════════════════════════════════════════════════════════╝

  # services.cloudflare-warp.enable = true;

  # ╔═══════════════════════════════════════════════════════════════╗
  # ║  LAYER 5: SING-BOX (backup — commented)                       ║
  # ║                                                               ║
  # ║  Modern proxy client for VLESS/Trojan/Hysteria.               ║
  # ║  Uncomment and add config when you have subscription links.   ║
  # ╚═══════════════════════════════════════════════════════════════╝

  # services.sing-box = {
  #   enable = true;
  #   settings = { };
  # };

  # ╔═══════════════════════════════════════════════════════════════╗
  # ║  PACKAGES                                                     ║
  # ╚═══════════════════════════════════════════════════════════════╝

  environment.systemPackages = with pkgs; [
    dig
    doggo
    curl
    wget
    httpie
    sing-box
  ];
}
