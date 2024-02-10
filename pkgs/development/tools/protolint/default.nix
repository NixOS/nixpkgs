{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "protolint";
  version = "0.47.5";

  src = fetchFromGitHub {
    owner = "yoheimuta";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xXl9MY0oBjyDlLVvpdV7nquxUxahfPslxJeOeUmwFgk=";
  };

  vendorHash = "sha256-62SxRvoN4ejmAczs823jftXUmeI4ozfb6plHYT1JwZ0=";

  # Something about the way we run tests causes issues. It doesn't happen
  # when using "go test" directly:
  # === RUN   TestEnumFieldNamesPrefixRule_Apply_fix/no_fix_for_a_correct_proto
  #    util_test.go:35: open : no such file or directory
  # === RUN   TestEnumFieldNamesPrefixRule_Apply_fix/fix_for_an_incorrect_proto
  #    util_test.go:35: open : no such file or directory
  excludedPackages = [ "internal" ];

  ldflags = let
    rev = builtins.substring 0 7 src.rev;
  in [
    "-X github.com/yoheimuta/protolint/internal/cmd.version=${version}"
    "-X github.com/yoheimuta/protolint/internal/cmd.revision=${rev}"
    "-X github.com/yoheimuta/protolint/internal/cmd/protocgenprotolint.version=${version}"
    "-X github.com/yoheimuta/protolint/internal/cmd/protocgenprotolint.revision=${rev}"
  ];

  meta = with lib; {
    description = "A pluggable linter and fixer to enforce Protocol Buffer style and conventions";
    homepage = "https://github.com/yoheimuta/protolint";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.zane ];
    mainProgram = "protolint";
  };
}
