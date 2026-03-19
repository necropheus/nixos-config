# AGENTS Guide for This Repository

This file is for coding agents working in `~/nix`.
Goal: give reliable validation commands and repo-specific style rules.

## Repository Scope

- Nix Flake repo for a NixOS + Home Manager setup.
- Entrypoint: `flake.nix`.
- NixOS modules: `nixos/`.
- Home Manager modules: `home-manager/`.
- Composition pattern: `default.nix` files aggregate imports.
- Treat `nixos/hardware-configuration.nix` as generated/machine-specific.

## Key Paths

- `flake.nix`: flake inputs/outputs.
- `nixos/configuration.nix`: NixOS root imports.
- `nixos/configs/`: OS config split by concern.
- `nixos/packages/`: OS package groups.
- `home-manager/default.nix`: HM root module.
- `home-manager/programs/`: user-space program modules.
- `home-manager/activation-scripts/`: HM activation hooks/scripts.

## Build, Lint, and Test Commands

Run from repo root: `/home/necropheus/nix`.

### Fast Validation

```bash
nix flake check --show-trace
```

- Best default sanity check before finishing work.
- Evaluates both `nixosConfigurations` and `homeConfigurations`.

### Build Checks (No Apply)

```bash
nix build .#nixosConfigurations.nixos.config.system.build.toplevel --dry-run
nix build .#homeConfigurations.necropheus.activationPackage --dry-run
```

- First validates full NixOS closure.
- Second validates HM activation package.

### Apply Changes Locally

```bash
sudo nixos-rebuild switch --flake .#nixos
home-manager switch --flake .#necropheus
```

### Safer Runtime Trial

```bash
sudo nixos-rebuild test --flake .#nixos
```

- Activates only for current boot/session.

### Linting

```bash
nix run nixpkgs#statix -- check .
nix run nixpkgs#deadnix -- .
```

- `statix`: style/simplification suggestions.
- `deadnix`: unused/dead bindings.

### Formatting

```bash
nix run nixpkgs#nixfmt -- flake.nix
nix run nixpkgs#nixfmt -- nixos/configs/networking.nix
```

- Format each changed `.nix` file explicitly.
- Prefer formatting only touched files for smaller diffs.

### Single-Test / Targeted Checks

There is no dedicated unit-test framework in this repo.
Use targeted eval/build/lint commands as "single test" equivalents.

```bash
# Fast single option evaluation
nix eval .#nixosConfigurations.nixos.config.services.openssh.enable

# Single-module lint
nix run nixpkgs#statix -- check nixos/configs/networking.nix

# Single output build validation
nix build .#homeConfigurations.necropheus.activationPackage --dry-run
```

- Pick the smallest command that proves your change is correct.

## Code Style Guidelines

### General

- Keep code in English.
- Keep modules focused: one concern per file.
- Prefer extending existing module trees instead of one-off root files.
- Keep diffs targeted; avoid unrelated cleanup.
- Stay inside flake workflow (no global package-install assumptions).

### Module Structure and Imports

- Typical shape:

```nix
{ pkgs, ... }:
{
  # options
}
```

- Compose modules with `imports = [ ... ];`.
- Keep import lists stable, usually alphabetical.
- Use `default.nix` as directory entrypoints for grouped modules.
- Accept only arguments you use (`pkgs`, `lib`, `config`, etc.).
- Pass dependencies explicitly via `inherit` for nested imports.

### Naming Conventions

- File names: kebab-case (example: `window-manager.nix`).
- Attr names: match upstream option names exactly.
- Local helpers: short lowerCamelCase (`flakeDir`, `neovimNightly`).
- Shell constants: UPPER_SNAKE_CASE (`HYPRPANEL_CONFIG_DIR`).

### Types and Values

- Use option-appropriate Nix types (bool/string/list/attrset/path).
- Keep booleans as booleans (not string equivalents).
- Prefer Nix paths for repo-local files.
- Use strings for command snippets and app config values.

### Shell and Activation Script Safety

- Guard filesystem operations (`if [ -d ... ]`, `if [ -f ... ]`).
- Quote variable expansions.
- Prefer explicit binaries from Nix store paths in activation hooks.
- Allow graceful failure for non-critical diagnostics (`|| true` when needed).
- Avoid destructive operations unless explicitly required.

### Comments and TODO/FIX Tags

- Keep comments brief and high-signal.
- Explain "why", not obvious "what".
- Use `TODO`/`FIX` only when actionable and specific.
- Do not leave placeholder comments without context.

### Secrets and Sensitive Data

- Never add plaintext secrets, API keys, tokens, or passwords.
- Do not commit machine-specific credentials.
- Prefer out-of-repo secret handling.

## Agent Workflow Expectations

- Make minimal, targeted edits.
- Validate changed modules with at least one targeted check.
- Run `nix flake check --show-trace` for larger or cross-cutting changes.
- If both NixOS and HM change, validate both outputs.
