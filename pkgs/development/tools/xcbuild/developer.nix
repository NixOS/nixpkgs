{ stdenv, platform, toolchain, xcbuild, writeText }:

let

  Tools = [
    {
      Identifier = "com.apple.build-tools.nmedit";
      Type = "Tool";
      Name = "Nmedit";
    }
    {
      Identifier = "com.apple.compilers.resource-copier";
      Type = "Tool";
      Name = "Resource Copier";
    }
    {
      Identifier = "com.apple.compilers.yacc";
      Type = "Tool";
      Name = "Yacc";
      InputFileTypes = [ "sourcecode.yacc" ];
      ExecDescription = "Yacc $(InputFile)";
    }
    {
      Identifier = "com.apple.compilers.lex";
      Type = "Tool";
      Name = "Lex";
      ExecDescription = "Lex $(InputFile)";
      InputFileTypes = [ "sourcecode.lex" ];
    }
  ];

  Architectures = [
    {
		  Identifier = "Standard";
	    Type = "Architecture";
		  Name = "Standard Architectures (64-bit Intel)";
		  RealArchitectures = [ "x86_64" ];
      ArchitectureSetting = "ARCHS_STANDARD";
    }
    {
      Identifier = "Universal";
      Type = "Architecture";
      Name = "Universal (64-bit Intel)";
      RealArchitectures = [ "x86_64" ];
      ArchitectureSetting = "ARCHS_STANDARD_32_64_BIT";
    }
    {
      Identifier = "Native";
      Type = "Architecture";
      Name = "Native Architecture of Build Machine";
      ArchitectureSetting = "NATIVE_ARCH_ACTUAL";
    }
    {
      Identifier = "Standard64bit";
      Type = "Architecture";
      Name = "64-bit Intel";
      RealArchitectures = [ "x86_64" ];
      ArchitectureSetting = "ARCHS_STANDARD_64_BIT";
    }
    {
      Identifier = "x86_64";
      Type = "Architecture";
      Name = "Intel 64-bit";
    }
    {
      Identifier = "Standard_Including_64_bit";
      Type = "Architecture";
      Name = "Standard Architectures (including 64-bit)";
      RealArchitectures = [ "x86_64" ];
		  ArchitectureSetting = "ARCHS_STANDARD_INCLUDING_64_BIT";
    }
  ];

  PackageTypes = [
    {
      Identifier = "com.apple.package-type.mach-o-executable";
      Type = "PackageType";
      Name = "Mach-O Executable";
      DefaultBuildSettings = {
        EXECUTABLE_NAME = "$(EXECUTABLE_PREFIX)$(PRODUCT_NAME)$(EXECUTABLE_VARIANT_SUFFIX)$(EXECUTABLE_SUFFIX)";
        EXECUTABLE_PATH = "$(EXECUTABLE_NAME)";
      };
      ProductReference = {
        FileType = "compiled.mach-o.executable";
        Name = "$(EXECUTABLE_NAME)";
      };
    }
    {
      Identifier = "com.apple.package-type.mach-o-objfile";
      Type = "PackageType";
      Name = "Mach-O Object File";
      DefaultBuildSettings = {
        EXECUTABLE_NAME = "$(EXECUTABLE_PREFIX)$(PRODUCT_NAME)$(EXECUTABLE_VARIANT_SUFFIX)$(EXECUTABLE_SUFFIX)";
        EXECUTABLE_PATH = "$(EXECUTABLE_NAME)";
      };
      ProductReference = {
        FileType = "compiled.mach-o.objfile";
        Name = "$(EXECUTABLE_NAME)";
      };
    }
    {
      Identifier = "com.apple.package-type.mach-o-dylib";
      Type = "PackageType";
      Name = "Mach-O Dynamic Library";
      DefaultBuildSettings = {
        EXECUTABLE_NAME = "$(EXECUTABLE_PREFIX)$(PRODUCT_NAME)$(EXECUTABLE_VARIANT_SUFFIX)$(EXECUTABLE_SUFFIX)";
        EXECUTABLE_PATH = "$(EXECUTABLE_NAME)";
      };
      ProductReference = {
        FileType = "compiled.mach-o.dylib";
        Name = "$(EXECUTABLE_NAME)";
      };
    }
  ];

  ProductTypes = [
    {
      Identifier = "com.apple.product-type.tool";
      Type = "ProductType";
      Name = "Command-line Tool";
      PackageTypes = [ "com.apple.package-type.mach-o-executable" ];
    }
    {
      Identifier = "com.apple.product-type.objfile";
      Type = "ProductType";
      Name = "Object File";
      PackageTypes = [ "com.apple.package-type.mach-o-objfile" ];
    }
    {
      Identifier = "com.apple.product-type.library.dynamic";
      Type = "ProductType";
      Name = "Dynamic Library";
      PackageTypes = [ "com.apple.package-type.mach-o-dylib" ];
    }
  ];

in

stdenv.mkDerivation {
  name = "Xcode.app";
  buildInputs = [ xcbuild ];
  buildCommand = ''
    mkdir -p $out/Contents/Developer/Library/Xcode/Specifications/
    cp ${xcbuild}/Library/Xcode/Specifications/* $out/Contents/Developer/Library/Xcode/Specifications/

    cd $out/Contents/Developer/Library/Xcode/Specifications/
    plutil -convert xml1 -o Tools.xcspec ${writeText "Tools.xcspec" (builtins.toJSON Tools)}
    plutil -convert xml1 -o Architectures.xcspec ${writeText "Architectures.xcspec" (builtins.toJSON Architectures)}
    plutil -convert xml1 -o PackageTypes.xcspec ${writeText "PackageTypes.xcspec" (builtins.toJSON PackageTypes)}
    plutil -convert xml1 -o ProductTypes.xcspec ${writeText "ProductTypes.xcspec" (builtins.toJSON ProductTypes)}

    mkdir -p $out/Contents/Developer/Platforms/
    cd $out/Contents/Developer/Platforms/
    ln -s ${platform}

    mkdir -p $out/Contents/Developer/Toolchains/
    cd $out/Contents/Developer/Toolchains/
    ln -s ${toolchain}
  '';
}
