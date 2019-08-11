{ stdenv, buildBazelPackage, lib, fetchFromGitHub, git, jre, makeWrapper }:

buildBazelPackage rec {
  name = "bazel-deps-${version}";
  version = "2019-07-11";

  meta = with stdenv.lib; {
    homepage = "https://github.com/johnynek/bazel-deps";
    description = "Generate bazel dependencies for maven artifacts";
    license = licenses.mit;
    maintainers = [ maintainers.uri-canva ];
    platforms = platforms.all;
    broken = true; # global variable '_common_attrs_for_plugin_bootstrapping' is referenced before assignment.
  };

  src = fetchFromGitHub {
    owner = "johnynek";
    repo = "bazel-deps";
    rev = "48fdf7f8bcf3aadfa07f9f7e6f0c9f4247cb0f58";
    sha256 = "0wpn5anfgq5wfljfhpn8gbgdmgcp0claffjgqcnv5dh70ch7i0gi";
  };

  bazelTarget = "//src/scala/com/github/johnynek/bazel_deps:parseproject_deploy.jar";

  buildInputs = [ git makeWrapper ];

  fetchAttrs = {
    sha256 = "1r5qxsbw2cgww7vcg5psh7404l3jcxpvc0ndgl3k8vj1x8y93nkf";
  };

  buildAttrs = {
    installPhase = ''
      mkdir -p $out/bin/bazel-bin/src/scala/com/github/johnynek/bazel_deps

      cp gen_maven_deps.sh $out/bin
      wrapProgram "$out/bin/gen_maven_deps.sh" --set JAVA_HOME "${jre}" --prefix PATH : ${lib.makeBinPath [ jre ]}
      cp bazel-bin/src/scala/com/github/johnynek/bazel_deps/parseproject_deploy.jar $out/bin/bazel-bin/src/scala/com/github/johnynek/bazel_deps
    '';
  };
}
