{ stdenv, runCommand, nettools, perl, kmod, writeTextFile, coffeescript }:

with stdenv.lib;

let

  # Function to parse the config file to get the features supported
  readFeatures = config:
    let
      configParser = writeTextFile { name = "config-parser"; executable=true; text = ''
        #!${coffeescript}/bin/coffee
        fs = require "fs"
        events = require "events"

        lineEmitter = new events.EventEmitter()
        buffer = new Buffer 0
        input = fs.createReadStream process.argv[2]
        input.on 'data', (data) ->
          nextBuffer = new Buffer buffer.length + data.length
          buffer.copy(nextBuffer)
          data.copy(nextBuffer, buffer.length)
          start = 0
          offset = buffer.length
          buffer = nextBuffer

          for i in [1..data.length]
              if data[i] == '\n'.charCodeAt 0
                  end = i+offset+1
                  line = buffer.slice start, end - 1
                  start = end
                  lineEmitter.emit "line", line.toString()

          buffer = buffer.slice start
        input.once 'end', ->
          input.destroy()
          if safeToWrite
            output.end "}"
            output.destroySoon()
          else
            output.once 'drain', ->
              output.end "}"
              output.destroySoon()

        output = fs.createWriteStream process.env["out"]
        output.setMaxListeners 0
        safeToWrite = output.write "{\n"
        unless safeToWrite
          output.once 'drain', ->
            safeToWrite = true

        escapeNixString = (str) ->
          str.replace("'''", "''''").replace("''${", "'''''${")
        lineEmitter.on 'line', (line) ->
          unless line.length is 0 or line.charAt(0) is '#'
            split = line.split '='
            name = split[0].substring "CONFIG_".length
            value = escapeNixString split.slice(1).join ""
            lineToWrite = "\"#{name}\" = '''#{value}''';\n"
            if safeToWrite
              safeToWrite = output.write lineToWrite
            else
              input.pause()
              output.once 'drain', ->
                safeToWrite = output.write lineToWrite
                input.resume()
      '';};

      configAttrs = import "${runCommand "attrList.nix" {} "${configParser} ${config}"}";

      getValue = option:
        if hasAttr option configAttrs then getAttr option configAttrs else null;

      isYes = option: (getValue option) == "y";
    in

    {
      modular = isYes "MODULES";
    };

in

{
  # The kernel version
  version,
  # The version of the kernel module directory
  modDirVersion ? version,
  # The kernel source (tarball, git checkout, etc.)
  src,
  # Any patches
  patches ? [],
  # The kernel .config file
  config,
  # Manually specified features the kernel supports
  # If unspecified, this will be autodetected from the .config
  features ? readFeatures config
}:

let
  commonMakeFlags = [
    "O=../build"
    "INSTALL_PATH=$(out)"
    "INSTALLKERNEL=${installkernel}"
  ];

  installkernel = writeTextFile { name = "installkernel"; executable=true; text = ''
    #!/bin/sh
    mkdir $4
    mv -v $2 $4
    mv -v $3 $4
  '';};
in

stdenv.mkDerivation ({
  name = "linux-${version}";

  enableParallelBuilding = true;

  passthru = {
    inherit version modDirVersion features;
  };

  inherit patches src;

  prePatch = ''
    for mf in $(find -name Makefile -o -name Makefile.include); do
        echo "stripping FHS paths in \`$mf'..."
        sed -i "$mf" -e 's|/usr/bin/||g ; s|/bin/||g ; s|/sbin/||g'
    done
  '';

  configurePhase = ''
    runHook preConfigure
    mkdir ../build
    make $makeFlags "''${makeFlagsArray[@]}" mrproper
    ln -sv ${config} ../build/.config
    make $makeFlags "''${makeFlagsArray[@]}" oldconfig
    rm ../build/.config.old
    runHook postConfigure
  '';

  buildNativeInputs = [ perl nettools kmod ];

  makeFlags = commonMakeFlags;

  meta = {
    description = "The Linux kernel";
    license = "GPLv2";
    homepage = http://www.kernel.org/;
    maintainers = [
      maintainers.shlevy
    ];
    platforms = lib.platforms.linux;
  };
} // optionalAttrs (features ? modular && features.modular) {
  makeFlags = commonMakeFlags ++ [
    "MODLIB=\"$(out)/lib/modules/${modDirVersion}\""
  ];

  postInstall = ''
    make modules_install $makeFlags "''${makeFlagsArray[@]}" \
      $installFlags "''${installFlagsArray[@]}"
    rm -f $out/lib/modules/${modDirVersion}/{build,source}
    cd ..
    mv $sourceRoot $out/lib/modules/${modDirVersion}/source
    mv build $out/lib/modules/${modDirVersion}/build
    unlink $out/lib/modules/${modDirVersion}/build/source
    ln -sv $out/lib/modules/${modDirVersion}/{,build/}source
  '';

  postFixup = ''
    if [ -z "$dontStrip" ]; then
        find $out -name "*.ko" -print0 | xargs -0 strip -S
    fi
  '';
})
