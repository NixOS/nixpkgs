{ stdenv, nodePackages, electron, nodejs }:

stdenv.mkDerivation rec {
  name = "electron-packager";
  version = "14.0.6";
  src = nodePackages."electron-packager-v${version}";

  buildInputs = [ electron nodejs ];

  buildPhase = ''
    # glue the version from nix's electron to electron-packager
    substituteInPlace ./lib/node_modules/electron-packager/src/infer.js \
      --replace "getVersion (opts, electronProp) {" \
                "getVersion (opts, electronProp) { \
                  opts.electronVersion = '${electron.version}'; \
                  return null;"

    # don't download, just copy over the electron distribution
    substituteInPlace ./lib/node_modules/electron-packager/src/index.js \
      --replace "const zipPath = await download.downloadElectronZip(downloadOpts)" \
                "const zipPath = '${electron}/lib/electron';" \
      --replace "await unzip(zipPath, buildDir)" \
                "await fs.copy(zipPath, buildDir)"

    # fallback to $tmp if tmpdir is not specifically provided
    substituteInPlace ./lib/node_modules/electron-packager/src/common.js \
      --replace 'opts.tmpdir || os.tmpdir()' \
                'process.env.TMP || opts.tmpdir || os.tmpdir()'

    # prevent EACCES: permission denied
    substituteInPlace ./lib/node_modules/electron-packager/src/platform.js \
      --replace "await this.removeDefaultApp()" "" \
      --replace "await fs.copy(this.opts.dir, this.originalResourcesAppDir" \
                "await fs.chmod( path.dirname(this.originalResourcesAppDir), \
                                 parseInt('755', 8)); \
                 await fs.ensureDir(this.originalResourcesAppDir);
                 await fs.copy(this.opts.dir, this.originalResourcesAppDir"
    '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r ./lib $out
    ln -s  $out/lib/node_modules/electron-packager/bin/electron-packager.js \
           $out/bin/electron-packager
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/oracle/graal;
    description = "Customize and package your Electron app with OS-specific bundles via JS or CLI";
    license = licenses.bsd2;
    maintainers = with maintainers; [ hlolli ];
    platforms = [ electron.meta.platforms ];
  };
}
