{pkgs, ...}: {
  # ╔═══════════════════════════════════════════════════════════════╗
  # ║  LAYER 0: BASE SYSTEM                                         ║
  # ╚═══════════════════════════════════════════════════════════════╝

  # ╔═══════════════════════════════════════════════════════════════╗
  # ║  LAYER 1: FIREWALL                                            ║
  # ╚═══════════════════════════════════════════════════════════════╝

  networking = {
    hostName = "nixos";

    networkmanager = {
      enable = true;
      dns = "none";
    };

    nameservers = ["127.0.0.1"];

    firewall = {
      enable = true;
      allowedTCPPorts = [2017];

      # IMPORTANT: Trust TUN interfaces for transparent proxy
      trustedInterfaces = ["tun0" "tun1"];
    };
  };

  # ╔═══════════════════════════════════════════════════════════════╗
  # ║  LAYER 2: ENCRYPTED DNS                                       ║
  # ╚═══════════════════════════════════════════════════════════════╝

  services.resolved.enable = false;

  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      listen_addresses = ["127.0.0.1:53"];
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
  # ║  LAYER 4: ANTI-DPI (Fragment)                                 ║
  # ║  TODO                                                         ║
  # ╚═══════════════════════════════════════════════════════════════╝

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
