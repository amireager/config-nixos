# Amir's NixOS Config

## Hosts

- nixos

## Rebuild system

sudo nixos-rebuild switch --flake .#nixos

## Rebuild home

home-manager switch --flake .#amir@nixos

## Update

nix flake update

## Format

nix fmt
