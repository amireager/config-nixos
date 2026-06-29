{
  pkgs,
  lib,
  ...
}: {
  # ═══════════════════════════════════════════
  # 1. HARDWARE & CONNECTIVITY (The Pipe)
  # ═══════════════════════════════════════════

  networking.hostName = "nixos";

  # Manage Wifi/Ethernet hardware
  networking.networkmanager.enable = true;

  # Tell NM: "You handle the cable/wifi, but DO NOT touch DNS files."
  networking.networkmanager.dns = "none";

  # Prevent conflicts with resolv.conf management
  networking.resolvconf.enable = false;
  services.resolved.enable = false;

  # Basic Firewall (allows outgoing, blocks unsolicited incoming)
  networking.firewall.enable = true;
  networking.firewall.allowedUDPPorts = [53];

  # ═══════════════════════════════════════════
  # 2. DNS LOCKDOWN (The Lock)
  # ═══════════════════════════════════════════

  # Hardcode the system resolver to our local proxy
  environment.etc."resolv.conf".text = lib.mkForce ''
    # Managed by NixOS - Local Dnscrypt Proxy
    nameserver 127.0.0.1
  '';

  # ═══════════════════════════════════════════
  # 3. DNSCRYPT PROXY (The Worker)
  # ═══════════════════════════════════════════

  services.dnscrypt-proxy = {
    enable = true;

    settings = {
      # Listen on local interface
      listen_addresses = ["127.0.0.1:53"];

      # --- SELF-HEALING / BOOTSTRAP LOGIC ---
      # Use direct IPs for initial connection so we don't need DNS to get DNS
      bootstrap_resolvers = ["9.9.9.9:53" "1.1.1.1:53" "8.8.8.8:53"];
      ignore_system_dns = true;

      # Check connectivity using an IP (doesn't need DNS resolution)
      netprobe_address = "1.1.1.1:53";
      netprobe_timeout = 30;
      # --------------------------------------

      # Minimal server list to start with
      # server_names = ["cloudflare"];

      # Fetch the full resolver list automatically
      sources.public-resolvers = {
        urls = [
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
        ];
        cache_file = "/var/cache/dnscrypt-proxy/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        refresh_delay = 72;
      };

      # Cache & Security
      cache = true;
      cache_size = 512;
      cache_min_ttl = 60;
      cache_max_ttl = 3600;

      ipv6_servers = false;
      block_ipv6 = true;

      require_dnssec = true;
      require_nolog = true;
      require_nofilter = true;
    };
  };

  # Fallback nameservers for the system config (mostly ignored by our hardcode above)
  networking.nameservers = ["127.0.0.1"];

  # ═══════════════════════════════════════════
  # 4. BYEDPI - DPI Bypass (YouTube, Twitter, ...)
  # ═══════════════════════════════════════════

  systemd.services.byedpi = {
    description = "ByeDPI DPI Bypass";
    after = ["network-online.target"];
    wants = ["network-online.target"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      ExecStart = "${pkgs.byedpi}/bin/ciadpi -p 1080 --disorder 1 --split 1+s --tlsrec 1+s --fake -1 --ttl 8";
      Restart = "always";
      RestartSec = 3;
      DynamicUser = true;
    };
  };

  # ═══════════════════════════════════════════
  # 5. V2RAYA - Proxy Management GUI
  # ═══════════════════════════════════════════

  services.v2raya = {
    enable = true;
    # SECURITY: v2raya web panel listens on port 2017 by default.
    # Make sure firewall blocks this port from external access:
    #   networking.firewall.allowedTCPPorts = [ ];  # do NOT add 2017 here
    # Or set a password in the v2raya web UI after first login.
  };

  # ═══════════════════════════════════════════
  # -- PACKAGES (The Tools)
  # ═══════════════════════════════════════════

  environment.systemPackages = with pkgs; [
    # DNS
    doggo # Modern DNS lookup tool

    # HTTP / Download
    curl # HTTP client
    wget # Download utility

    # Debugging
    tcpdump # Network sniffer

    # DPI Bypass
    byedpi # Lightweight DPI circumvention

    # --- Proxy Platforms ---
    xray # VLESS/VMess/Reality proxy platform
    sing-box # Modern all-in-one proxy platform

    # --- Per-App Proxy ---
    torsocks # Syscall-level SOCKS5 (any SOCKS5, not just Tor)
    proxychains-ng # Config-based per-app proxy (different config per proxy)

    # --- Free Tunneling ---
    cloudflared # Cloudflare WARP tunnel (free, no server)
    tor # Tor network (slow but reliable fallback)

    wgcf # Generate WireGuard config from Cloudflare WARP account
    wireguard-tools # WireGuard VPN tools

    # --- Proxy Management GUI ---
    v2rayn # Web GUI: manage subscriptions, test nodes, routing
  ];
}
