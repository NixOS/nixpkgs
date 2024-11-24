{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  olm,
  libsignal-ffi,
  versionCheckHook,
  # This option enables the use of an experimental pure-Go implementation of
  # the Olm protocol instead of libolm for end-to-end encryption. Using goolm
  # is not recommended by the mautrix developers, but they are interested in
  # people trying it out in non-production-critical environments and reporting
  # any issues they run into.
  withGoolm ? false,
}:

buildGoModule rec {
  pname = "mautrix-signal";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "signal";
    rev = "v${version}";
    hash = "sha256-KGIlLGGVaySRrHt6P2AlnDEew/ERyrDYyN2lOz3318M=";
  };

  patches = [
    # fixes broken media uploads, will be included in the next release
    (fetchpatch {
      url = "https://github.com/mautrix/signal/commit/b09995a892c9930628e1669532d9c1283a4938c8.patch";
      hash = "sha256-M8TvCLZG5MbD/Bkpo4cxQf/19dPfbGzMyIPn9utPLco=";
    })
  ];

  buildInputs =
    (lib.optional (!withGoolm) olm)
    ++ (lib.optional withGoolm stdenv.cc.cc.lib)
    ++ [
      # must match the version used in https://github.com/mautrix/signal/tree/main/pkg/libsignalgo
      # see https://github.com/mautrix/signal/issues/401
      libsignal-ffi
    ];

  tags = lib.optional withGoolm "goolm";

  CGO_LDFLAGS = lib.optional withGoolm [ "-lstdc++" ];

  vendorHash = "sha256-bKQKO5RqgMrWq7NyNF1rj2CLp5SeBP80HWxF8MWnZ1U=";

  doCheck = true;
  preCheck =
    ''
      # Needed by the tests to be able to find libstdc++
      export LD_LIBRARY_PATH="${stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH"
    ''
    + (lib.optionalString (!withGoolm) ''
      # When using libolm, the tests need explicit linking to libstdc++
      export CGO_LDFLAGS="-lstdc++"
    '');

  postCheck = ''
    unset LD_LIBRARY_PATH
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];

  meta = with lib; {
    homepage = "https://github.com/mautrix/signal";
    description = "Matrix-Signal puppeting bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [
      niklaskorz
      ma27
    ];
    mainProgram = "mautrix-signal";
  };
}
