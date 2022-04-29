{ stdenv
, fetchFromGitHub
, rustc
, cargo
, rustPlatform
, pkg-config
, dbus
, glib
, cairo
, pango
, atk
, lib
, gdk-pixbuf
, gtk3
}:

rustPlatform.buildRustPackage.override { stdenv = stdenv; } rec {
  pname = "popsicle";
  version = "unstable-2021-12-20";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "b02ebf5f2e6c18777453ca9a144d69689a6fa901";
    sha256 = "03ilhvnr4mwy7b8bipp616h16m2ilxzxz2zjpkzy3afwvh9bz1mx";
  };

  cargoSha256 = "1c54wxyrfxk5chnjhxw6vaznm7ff9dkx1rxlgp417jfygiwijjs4";

  nativeBuildInputs = [ gtk3 pkg-config ];

  buildInputs = [
    gtk3
    dbus
    glib
    cairo
    pango
    atk
    gdk-pixbuf
  ];

  # Use the stdenv default phases (./configure; make) instead of the
  # ones from buildRustPackage.
  configurePhase = "configurePhase";
  buildPhase = "buildPhase";
  checkPhase = "checkPhase";
  installPhase = "installPhase";

  postPatch = ''
    # Have to do this here instead of in preConfigure because
    # cargoDepsCopy gets unset after postPatch.
    configureFlagsArray+=("RUST_VENDORED_SOURCES=$NIX_BUILD_TOP/$cargoDepsCopy")
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "DESTDIR=${placeholder "out"}"
  ];

  postInstall = ''
    # install man page, icon, etc...
    mv $out/usr/local/* $out
    rm -rf $out/usr
  '';

  meta = with lib; {
    description = "Multiple USB File Flasher";
    homepage = "https://github.com/pop-os/popsicle";
    maintainers = with maintainers; [ _13r0ck ];
    license = licenses.mit;
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
}
