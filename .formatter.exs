[
  import_deps: [:phoenix],
  inputs:
    Enum.flat_map(
      ["*.{ex,exs}", "{config,lib,test}/**/*.{ex,exs}"],
      &Path.wildcard(&1, match_dot: true)
    ) --
      ["lib/snake/encoder.ex"]
]
