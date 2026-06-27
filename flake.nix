{
  description = "Amir's Modular NixOS Flake - Optimized for 2026";

  inputs = {
    # Core: NixOS Unstable for the latest packages and drivers
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Desktop: Niri scrollable tiling compositor
    niri = {
      url = "github:YaLTeR/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Browser: Zen Firefox fork
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # User Management: Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
    username = "amir";
    hostname = "nixos";

    flakePath = "/home/${username}/nixos-config";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    specialArgs = {
      inherit inputs username hostname system flakePath;
    };
  in {
    nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
      inherit system specialArgs;

      modules = [
        # Host-specific NixOS configuration
        ./hosts/nixos/configuration.nix

        # Home Manager as a NixOS module
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            extraSpecialArgs = specialArgs;

            # Main Home Manager entry point for user 'amir'
            users.${username} = import ./home/amir;
          };
        }
      ];
    };

    # Standalone Home Manager target.
    # Use this for fast user-level rebuilds:
    #   home-manager switch --flake .#amir@nixos
    homeConfigurations."${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = specialArgs;
      modules = [
        ./home/amir
      ];
    };

    # Optional formatter for this flake:
    #   nix fmt
    formatter.${system} = pkgs.alejandra;
  };
}
