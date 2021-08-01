{
  stdenv, lib, fetchgit, fetchurl, makeWrapper,
  jre, maven, buildMaven, javaPackages
}:

let
  fetchMaven = javaPackages.fetchMaven;
  repository = (buildMaven ./project-info.json).repo;

  # buildMaven doesn't seem to download the following stuff (?)
  junit-bom-pom = fetchMaven {
    groupId = "org.junit";
    artifactId = "junit-bom";
    version = "5.6.1";
    sha512 = "28sv3zxbc5zgmydmg5nkrvdfy2z186p24npa85cawvwrzhcbkc3140g5g8a8zcm759773kmgfsycdcclpfppnx6pk9815zz44sg94y7";
    type = "pom";
  };
  xtend-lib-jar = fetchMaven {
    groupId = "org.eclipse.xtend";
    artifactId = "org.eclipse.xtend.lib";
    version = "2.16.0.M1";
    sha512 = "39dnjsaz367rfyjk510pilw7nvsiiwp1vby9z8gzg0cm4lczzc4f04mb06m32pdz1s524162l0m0vih6nkx09fm6gndch4vr9idm0b8";
    type = "jar";
  };
  xtend-lib-pom = fetchMaven {
    groupId = "org.eclipse.xtend";
    artifactId = "org.eclipse.xtend.lib";
    version = "2.16.0.M1";
    sha512 = "07a5smxnrw8yfb6i4p63y8hm04y4pzp59nnb6smhbklvqxz8274sxis4jkxcs77q1rs073llyq6d2jz1dr0c1w8kxpv19r345dndf8b";
    type = "pom";
  };
  xtend-macro-jar = fetchMaven {
    groupId = "org.eclipse.xtend";
    artifactId = "org.eclipse.xtend.lib.macro";
    version = "2.16.0.M1";
    sha512 = "2ihfb5xrdklsdm4aw286ipkn0bkg81pnpz58rih54hshmwby3l17c899kqpmin0dzsgc7r28x79v3hk23pn8wx9ca1amkynbci75n4w";
    type = "jar";
  };
  xtext-jar = fetchMaven {
    groupId = "org.eclipse.xtext";
    artifactId = "org.eclipse.xtext.xbase.lib";
    version = "2.16.0.M1";
    sha512 = "3xyxwhrbr8j8x0y86l0rp766ycp3c22cf58n1ai4d7p8350rjkmwkxc7m6rmbdyn0k2213hrwy4j0hlvzhsf6smdv74r9fsf3dqladk";
    type = "jar";
  };
  plexus = fetchMaven {
    groupId = "org.codehaus.plexus";
    artifactId = "plexus-component-annotations";
    version = "1.7.1";
    sha512 = "2ldx7damgab5z99ay0j8hg8bypsfjl7cxsyr5p04xjz54spp6g9ysad7cfgwqvbzxka43z4xma6b30kc9iw6iggampi597xngysj2p2";
    type = "jar";
  };
  plexus-utils = fetchMaven {
    groupId = "org.codehaus.plexus";
    artifactId = "plexus-utils";
    version = "1.1";
    sha512 = "36k6grn4as4ka3diizwvybcfsn4spqqmqxvsaf66iq1zi2vxj3rsfr4xq6isv3p8f09wnnv9jm9xqqz4z0n3ah5mi8z1p5zhskcm5fs";
    type = "jar";
  };
  artifact-filters = fetchMaven {
    groupId = "org.apache.maven.shared";
    artifactId = "maven-common-artifact-filters";
    version = "3.1.0";
    sha512 = "00qyx6bks75kxvrd14l5vqvgw1g133wwsgkdsqzk9dxz0p9cby6yjzx320adi6phdbkb8dj1rxi73xb3f9bf9gfl4znxbr3v5ww64x2";
    type = "jar";
  };
  commons-compress = fetchMaven {
    groupId = "org.apache.commons";
    artifactId = "commons-compress";
    version = "1.13";
    sha512 = "2dys7zp8s60lih14l96073flrn55slxmc3ibx5nmqh1hizpmwkxrfk4yyz3m8g3sn754c7fwv0nrrhmzkb483393firnxachkvvbxpm";
    type = "jar";
  };
  guava = fetchMaven {
    groupId = "com.google.guava";
    artifactId = "guava";
    version = "20.0";
    sha512 = "168wfkkrkdvs7l4kqa8w2ixlc4m1q724i527fgsnb4bldibaglvgf6cb9203lygjg84r5cr16sbia0mmwca2j4mq19d0bfza58nnwyq";
    type = "jar";
  };
  checkstyle-jar = fetchurl {
    url = "https://repo.eclipse.org/content/groups/releases/org/eclipse/cbi/checkstyle/1.0.1/checkstyle-1.0.1.jar";
    sha256 = "0y91d4r6bhk9m3h3zd4dplwvg27qz8jhhdgicxwnlh1k3qmbg7fq";
  };
  checkstyle-pom = fetchurl {
    url = "https://repo.eclipse.org/content/groups/releases/org/eclipse/cbi/checkstyle/1.0.1/checkstyle-1.0.1.pom";
    sha256 = "1ywd9qkmfvcdbm2r65wx1p0k0bdl0l3yc3sgplnk21jkgl53ci1f";
  };
  # not available via fetchMaven (?)
  # checkstyle = fetchMaven {
  #   groupId = "org.eclipse.cbi";
  #   artifactId = "checkstyle";
  #   version = "1.0.1";
  #   sha512 = "168wfkkrkdvs7l4kqa8w2ixlc4m1q724i527fgsnb4bldibaglvgf6cb9203lygjg84r5cr16sbia0mmwca2j4mq19d0bfza58nnwyq";
  #   type = "jar";
  # };
in
stdenv.mkDerivation rec {
  pname = "lemminx";
  version = "0.17.1";

  # build requires the .git dir
  src = fetchgit {
    url = "https://github.com/eclipse/lemminx.git";
    rev = version;
    sha256 = "sha256-mpDm/fKLKbZ8P36+X/8YgXFFJBQMQ2DY3y0du6R0KJE=";
    leaveDotGit = true;
  };

  # https://discourse.nixos.org/t/keep-git-folder-in-when-fetching-a-git-repo/8590/6
  # src = fetchFromGitHub {
  #   owner = "eclipse";
  #   repo = pname;
  #   rev = version;
  #   sha256 = "0kxrhchy7gamxavvcnzvkzcxzrmzj04hyrw3h9j3j5clz94n4wf0";
  # };

  buildPhase = with lib; ''
    runHook preBuild

    # There has to be a better way!
    mkdir .maven
    cp -R ${repository}/* ./.maven/
    chown -R nixbld:nixbld ./.maven/
    chmod -R +w ./.maven/
    cp -R ${junit-bom-pom}/m2/* .maven/
    cp -R ${xtend-lib-jar}/m2/* .maven/
    chmod -R +w ./.maven/
    cp -R ${xtend-lib-pom}/m2/* .maven/
    cp -R ${xtend-macro-jar}/m2/* .maven/
    cp -R ${xtext-jar}/m2/* .maven/
    cp -R ${plexus}/m2/* .maven/
    chmod -R +w ./.maven/
    cp -R ${plexus-utils}/m2/* .maven/
    cp -R ${artifact-filters}/m2/* .maven/
    cp -R ${commons-compress}/m2/* .maven/
    cp -R ${guava}/m2/* .maven/

    mkdir -p .maven/org/eclipse/cbi/checkstyle/1.0.1/
    cp -R ${checkstyle-jar} .maven/org/eclipse/cbi/checkstyle/1.0.1/checkstyle-1.0.1.jar
    cp -R ${checkstyle-pom} .maven/org/eclipse/cbi/checkstyle/1.0.1/checkstyle-1.0.1.pom

    ${maven}/bin/mvn package --offline -Dmaven.repo.local=.maven -DskipTests
    # TODO make native image with Graal

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r org.eclipse.lemminx/target/* $out

    makeWrapper ${jre}/bin/java $out/bin/lemminx \
      --add-flags "-cp $out/org.eclipse.lemminx-uber.jar org.eclipse.lemminx.XMLServerSocketLauncher"

    runHook postInstall
  '';

  nativeBuildInputs = [ makeWrapper ];

  meta = with lib; {
    description = "XML Language Server";
    homepage = "https://github.com/eclipse/lemminx";
    license = licenses.epl20;
    maintainers = with maintainers; [ mausch ];
    platforms = platforms.all;
  };
}
