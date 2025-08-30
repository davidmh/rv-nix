rv nix flake
------------

Nix flake overlay for [rv: Next-gen very fast Ruby tooling][rv]

## Overview

This project provides a Nix flake for building and developing [rv], with
reproducible builds and easy development environments.

## Usage

### Using the Flake

You can use this flake to build and develop `rv` with Nix.
To build the default package or enter a development shell, run:

```sh
nix build
nix develop
```

This will use the Rust toolchain specified in the flake (currently Rust 1.88.0
via [oxalica/rust-overlay]).

### As an Input in Another Flake

To use this flake in another project, add it to your `flake.nix` inputs:

```nix
inputs.rv-nix.url = "github:davidmh/rv-nix";
```

Then, reference the package in your outputs:

```nix
outputs = { self, rv-nix, ... }: {
  packages.x86_64-linux.rv = rv-nix.packages.x86_64-linux.default;
};
```

### Overriding the rv Revision

By default, this flake uses the revision specified in `inputs.rv-src.url`.
To override the revision (for example, to use a different tag, branch, or
commit), update the `rv-src` input in your `flake.nix`:

```nix
inputs.rv-src = {
  flake = false;
  url = "github:spinel-coop/rv/<your-desired-revision>";
};
```

Replace `<your-desired-revision>` with a tag, branch, or commit hash.

**Example:**
```nix
inputs.rv-src = {
  flake = false;
  url = "github:spinel-coop/rv/v0.2.0";
};
```

## License

MIT

[rv]: https://github.com/spinel-coop/rv
[oxalica/rust-overlay]: https://github.com/oxalica/rust-overlay
