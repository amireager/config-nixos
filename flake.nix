{
  description = "Amir's Modular NixOS Flake - Optimized for 2026";

  inputs = {
    # Core: NixOS Unstable for the latest packages and drivers
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Desktop: Niri (Scrollable tiling compositor)
    niri.url = "github:YaLTeR/niri";

    # UI Framework: Quickshell (The backbone for our custom bar/control center)
    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Browser: Zen (Modern, privacy-focused Firefox fork)
    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    # User Management: Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      # Pass flake inputs to all modules for easy access via 'inputs'
      specialArgs = { inherit inputs; };

      modules = [
        # 1. Hardware and System-level configuration
        ./hosts/nixos/configuration.nix
        
        # 2. Host-specific platform setting
        { nixpkgs.hostPlatform = "x86_64-linux"; }

        # 3. Home-manager setup as a NixOS module
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            
            # The entry point for the user 'amir'
            users.amir = import ./home/default.nix;

            # Safety: Rename existing config files instead of failing the build
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
