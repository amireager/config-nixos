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

  services.dnscrypt-proxy2 = {
    enable = true;

    settings = {
      # Listen on local interface
      listen_addresses = ["127.0.0.1:53"];

      # --- SELF-HEALING / BOOTSTRAP LOGIC ---
      # Use direct IPs for initial connection so we don't need DNS to get DNS
      bootstrap_resolvers = ["1.1.1.1:53" "8.8.8.8:53"];
      ignore_system_dns = true;

      # Check connectivity using an IP (doesn't need DNS resolution)
      netprobe_address = "1.1.1.1:53";
      netprobe_timeout = 30;
      # --------------------------------------

      # Minimal server list to start with
      server_names = ["cloudflare"];

      # Fetch the full resolver list automatically
      sources.public-resolvers = {
        urls = [
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/cache/dnscrypt-proxy/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        refresh_delay = 72;
      };

      # Cache & Security
      cache = true;
      cache_size = 512;
      cache_min_ttl = 600;
      cache_max_ttl = 86400;

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
  # 4. PACKAGES (The Tools)
  # ═══════════════════════════════════════════

  environment.systemPackages = with pkgs; [
    doggo # Modern DNS lookup tool
    curl # HTTP client
    wget # Download utility
    httpie # User-friendly HTTP client
    dig # (part of bind) Standard DNS tool
    tcpdump # Network sniffer (useful for debugging)
  ];
}
