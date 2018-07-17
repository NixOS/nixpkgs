{ stdenv, fetchurl, mono, dpkg }:

stdenv.mkDerivation rec {
  name = "msbuild-${version}";
  version = "15.6";

  src = fetchurl {
    url = "https://download.mono-project.com/repo/ubuntu/pool/main/m/msbuild/msbuild_15.6+xamarinxplat.2018.01.17.14.14-0xamarin2+ubuntu1404b1_all.deb";
    sha256 = "0jgw80p9dr9mi40i8vy22y3b5d4byr26s9gvs5xjjgdzqdrlj9fm";
  };

  nativeBuildInputs = [ dpkg ];

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = "dpkg-deb -x $src .";
  installPhase = "
    substituteInPlace usr/bin/msbuild --replace /usr/bin/mono ${mono}/bin/mono --replace /usr/lib/mono/msbuild/15.0/bin/MSBuild.dll '$(dirname $0)/../usr/lib/mono/msbuild/15.0/bin/MSBuild.dll'
    mv usr/bin .
    cp -r . $out
    rm $out/env-vars
    cp -r ${mono}/lib/mono/msbuild/15.0/bin/Roslyn $out/usr/lib/mono/msbuild/15.0/bin/Roslyn
    cp -r ${mono}/lib/mono/4.5 $out/usr/lib/mono/4.5
  ";

  meta = with stdenv.lib; {
    description = "The Microsoft Build Engine (MSBuild) is the build platform for .NET and Visual Studio";
    homepage = https://github.com/Microsoft/msbuild;
    license = licenses.mit;
    maintainers = with maintainers; [ leo60228 ];
    platforms = platforms.unix;
  };
}
