# Patched lldb for Rust language support.
{ lldb_11, fetchFromGitHub }:
let
  llvmSrc = fetchFromGitHub {
    owner = "vadimcn";
    repo = "llvm-project";
    rev = "dd7efd9ea2d38e3227bc2e83a99772aceeb44242";
    sha256 = "sha256-XY8J8Ie1cWb6ok72Gju/KUxZ4fIFQVitYVnuCezGRKQ=";
  };
in lldb_11.overrideAttrs (oldAttrs: {
  src = "${llvmSrc}/lldb";

  passthru = (oldAttrs.passthru or {}) // {
    inherit llvmSrc;
  };

  doInstallCheck = true;
  postInstallCheck = (oldAttrs.postInstallCheck or "") + ''
    versionOutput="$($out/bin/lldb --version)"
    echo "'lldb --version' returns: $versionOutput"
    echo "$versionOutput" | grep -q 'rust-enabled'
  '';
})
