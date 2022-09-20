{ pkgs }:

with pkgs;

let
  mavenbuild = callPackage ../development/java-modules/build-maven-package.nix { };
  fetchMaven = callPackage ../development/java-modules/m2install.nix { };

  openjfx11 = callPackage ../development/compilers/openjdk/openjfx/11.nix { };
  openjfx15 = callPackage ../development/compilers/openjdk/openjfx/15.nix { };
  openjfx17 = callPackage ../development/compilers/openjdk/openjfx/17.nix { };

  mavenfod = callPackage ../development/java-modules/maven-fod.nix { };

in {
  inherit mavenbuild mavenfod fetchMaven openjfx11 openjfx15 openjfx17;

  compiler = let

    gnomeArgs = {
      inherit (gnome2) GConf gnome_vfs;
    };

    bootstrapArgs = gnomeArgs // {
      openjfx = openjfx11; /* need this despite next line :-( */
      enableJavaFX = false;
      headless = true;
    };

    mkAdoptopenjdk = path-linux: path-darwin: let
      package-linux  = import path-linux { inherit lib; };
      package-darwin = import path-darwin { inherit lib; };
      package = if stdenv.isLinux
        then package-linux
        else package-darwin;
    in rec {
      inherit package-linux package-darwin;

      jdk-hotspot = callPackage package.jdk-hotspot {};
      jre-hotspot = callPackage package.jre-hotspot {};
      jdk-openj9  = callPackage package.jdk-openj9  {};
      jre-openj9  = callPackage package.jre-openj9  {};
    };

    mkBootstrap = adoptopenjdk: path: args:
      /* adoptopenjdk not available for i686, so fall back to our old builds for bootstrapping */
      if   adoptopenjdk.jdk-hotspot.meta.available
      then adoptopenjdk.jdk-hotspot
      else callPackage path args;

    mkOpenjdk = path-linux: path-darwin: args:
      if stdenv.isLinux
      then mkOpenjdkLinuxOnly path-linux args
      else let
        openjdk = callPackage path-darwin {};
      in openjdk // { headless = openjdk; };

    mkOpenjdkLinuxOnly = path-linux: args: let
      openjdk = callPackage path-linux  (gnomeArgs // args);
    in openjdk // {
      headless = openjdk.override { headless = true; };
    };

    openjdkDarwinMissing = version:
      abort "OpenJDK ${builtins.toString version} is currently not supported on Darwin by nixpkgs.";

  in rec {

    adoptopenjdk-8 = mkAdoptopenjdk
      ../development/compilers/adoptopenjdk-bin/jdk8-linux.nix
      ../development/compilers/adoptopenjdk-bin/jdk8-darwin.nix;

    adoptopenjdk-11 = mkAdoptopenjdk
      ../development/compilers/adoptopenjdk-bin/jdk11-linux.nix
      ../development/compilers/adoptopenjdk-bin/jdk11-darwin.nix;

    adoptopenjdk-13 = mkAdoptopenjdk
      ../development/compilers/adoptopenjdk-bin/jdk13-linux.nix
      ../development/compilers/adoptopenjdk-bin/jdk13-darwin.nix;

    adoptopenjdk-14 = mkAdoptopenjdk
      ../development/compilers/adoptopenjdk-bin/jdk14-linux.nix
      ../development/compilers/adoptopenjdk-bin/jdk14-darwin.nix;

    adoptopenjdk-15 = mkAdoptopenjdk
      ../development/compilers/adoptopenjdk-bin/jdk15-linux.nix
      ../development/compilers/adoptopenjdk-bin/jdk15-darwin.nix;

    adoptopenjdk-16 = mkAdoptopenjdk
      ../development/compilers/adoptopenjdk-bin/jdk16-linux.nix
      ../development/compilers/adoptopenjdk-bin/jdk16-darwin.nix;

    adoptopenjdk-17 = mkAdoptopenjdk
      ../development/compilers/adoptopenjdk-bin/jdk17-linux.nix
      ../development/compilers/adoptopenjdk-bin/jdk17-darwin.nix;

    openjdk8-bootstrap = mkBootstrap adoptopenjdk-8
      ../development/compilers/openjdk/bootstrap.nix
      { version = "8"; };

    openjdk11-bootstrap = mkBootstrap adoptopenjdk-11
      ../development/compilers/openjdk/bootstrap.nix
      { version = "10"; };

    openjdk13-bootstrap = mkBootstrap adoptopenjdk-13
      ../development/compilers/openjdk/12.nix
      (bootstrapArgs // {
        /* build segfaults with gcc9 or newer, so use gcc8 like Debian does */
        stdenv = gcc8Stdenv;
      });

    openjdk14-bootstrap = mkBootstrap adoptopenjdk-14
      ../development/compilers/openjdk/13.nix
      (bootstrapArgs // {
        inherit openjdk13-bootstrap;
      });

    openjdk15-bootstrap = mkBootstrap adoptopenjdk-15
      ../development/compilers/openjdk/14.nix
      (bootstrapArgs // {
        inherit openjdk14-bootstrap;
      });

    openjdk16-bootstrap = mkBootstrap adoptopenjdk-16
      ../development/compilers/openjdk/15.nix
      (bootstrapArgs // {
        inherit openjdk15-bootstrap;
      });

    openjdk17-bootstrap = mkBootstrap adoptopenjdk-17
      ../development/compilers/openjdk/16.nix
      (bootstrapArgs // {
        inherit openjdk16-bootstrap;
      });

    openjdk18-bootstrap = mkBootstrap adoptopenjdk-17
      ../development/compilers/openjdk/17.nix
      (bootstrapArgs // {
        inherit openjdk17-bootstrap;
      });

    openjdk8 = mkOpenjdk
      ../development/compilers/openjdk/8.nix
      ../development/compilers/openjdk/darwin/8.nix
      { };

    openjdk11 = mkOpenjdk
      ../development/compilers/openjdk/11.nix
      ../development/compilers/openjdk/darwin/11.nix
      { openjfx = openjfx11; };

    openjdk12 = mkOpenjdkLinuxOnly ../development/compilers/openjdk/12.nix {
        /* build segfaults with gcc9 or newer, so use gcc8 like Debian does */
        stdenv = gcc8Stdenv;
        openjfx = openjfx11;
    };

    openjdk13 = mkOpenjdkLinuxOnly ../development/compilers/openjdk/13.nix {
      inherit openjdk13-bootstrap;
      openjfx = openjfx11;
    };

    openjdk14 = mkOpenjdkLinuxOnly ../development/compilers/openjdk/14.nix {
      inherit openjdk14-bootstrap;
      openjfx = openjfx11;
    };

    openjdk15 = mkOpenjdkLinuxOnly ../development/compilers/openjdk/15.nix {
      inherit openjdk15-bootstrap;
      openjfx = openjfx15;
    };

    openjdk16 = mkOpenjdk
      ../development/compilers/openjdk/16.nix
      ../development/compilers/openjdk/darwin/16.nix
      {
        inherit openjdk16-bootstrap;
        openjfx = openjfx15;
      };

    openjdk17 = mkOpenjdk
      ../development/compilers/openjdk/17.nix
      ../development/compilers/openjdk/darwin/17.nix
      {
        inherit openjdk17-bootstrap;
        openjfx = openjfx17;
      };

    openjdk18 = mkOpenjdk
      ../development/compilers/openjdk/18.nix
      ../development/compilers/openjdk/darwin/18.nix
      {
        inherit openjdk18-bootstrap;
        openjfx = openjfx17;
      };

    temurin-bin = recurseIntoAttrs (callPackage (
      if stdenv.isLinux
      then ../development/compilers/temurin-bin/jdk-linux.nix
      else ../development/compilers/temurin-bin/jdk-darwin.nix
    ) {});

    semeru-bin = recurseIntoAttrs (callPackage (
      if stdenv.isLinux
      then ../development/compilers/semeru-bin/jdk-linux.nix
      else ../development/compilers/semeru-bin/jdk-darwin.nix
    ) {});
  };

  mavenPlugins = recurseIntoAttrs (callPackage ../development/java-modules/mavenPlugins.nix { });

  inherit (callPackage ../development/java-modules/eclipse/aether-util.nix { inherit fetchMaven; })
    aetherUtil_0_9_0_M2;

  inherit (callPackage ../development/java-modules/apache/ant.nix { inherit fetchMaven; })
    ant_1_8_2;

  inherit (callPackage ../development/java-modules/apache/ant-launcher.nix { inherit fetchMaven; })
    antLauncher_1_8_2;

  inherit (callPackage ../development/java-modules/beanshell/bsh.nix { inherit fetchMaven; })
    bsh_2_0_b4;

  inherit (callPackage ../development/java-modules/classworlds/classworlds.nix { inherit fetchMaven; })
    classworlds_1_1_alpha2
    classworlds_1_1;

  inherit (callPackage ../development/java-modules/apache/commons-cli.nix { inherit fetchMaven; })
    commonsCli_1_0
    commonsCli_1_2;

  inherit (callPackage ../development/java-modules/apache/commons-io.nix { inherit fetchMaven; })
    commonsIo_2_1;

  inherit (callPackage ../development/java-modules/apache/commons-lang.nix { inherit fetchMaven; })
    commonsLang_2_1
    commonsLang_2_3
    commonsLang_2_6;

  inherit (callPackage ../development/java-modules/apache/commons-lang3.nix { inherit fetchMaven; })
    commonsLang3_3_1;

  inherit (callPackage ../development/java-modules/apache/commons-logging-api.nix { inherit fetchMaven; })
    commonsLoggingApi_1_1;

  inherit (callPackage ../development/java-modules/findbugs/jsr305.nix { inherit fetchMaven; })
    findbugsJsr305_2_0_1;

  inherit (callPackage ../development/java-modules/google/collections.nix { inherit fetchMaven; })
    googleCollections_1_0;

  inherit (callPackage ../development/java-modules/hamcrest/all.nix { inherit fetchMaven; })
    hamcrestAll_1_3;

  inherit (callPackage ../development/java-modules/hamcrest/core.nix { inherit fetchMaven; })
    hamcrestCore_1_3;

  inherit (callPackage ../development/java-modules/junit { inherit mavenbuild fetchMaven; })
    junit_3_8_1
    junit_3_8_2
    junit_4_12;

  inherit (callPackage ../development/java-modules/jogl { })
    jogl_2_3_2;

  inherit (callPackage ../development/java-modules/log4j { inherit fetchMaven; })
    log4j_1_2_12;

  inherit (callPackage ../development/java-modules/maven/archiver.nix { inherit fetchMaven; })
    mavenArchiver_2_5;

  inherit (callPackage ../development/java-modules/maven/artifact.nix { inherit fetchMaven; })
    mavenArtifact_2_0_1
    mavenArtifact_2_0_6
    mavenArtifact_2_0_8
    mavenArtifact_2_0_9
    mavenArtifact_2_2_1
    mavenArtifact_3_0_3;

  inherit (callPackage ../development/java-modules/maven/artifact-manager.nix { inherit fetchMaven; })
    mavenArtifactManager_2_0_1
    mavenArtifactManager_2_0_6
    mavenArtifactManager_2_0_9
    mavenArtifactManager_2_2_1;

  inherit (callPackage ../development/java-modules/maven/common-artifact-filters.nix { inherit fetchMaven; })
    mavenCommonArtifactFilters_1_2
    mavenCommonArtifactFilters_1_3
    mavenCommonArtifactFilters_1_4;

  inherit (callPackage ../development/java-modules/maven/compiler-plugin.nix { inherit fetchMaven; })
    mavenCompiler_3_2;

  inherit (callPackage ../development/java-modules/maven/core.nix { inherit fetchMaven; })
    mavenCore_2_0_1
    mavenCore_2_0_6
    mavenCore_2_0_9
    mavenCore_2_2_1;

  inherit (callPackage ../development/java-modules/maven/dependency-tree.nix { inherit fetchMaven; })
    mavenDependencyTree_2_1;

  inherit (callPackage ../development/java-modules/maven/doxia-sink-api.nix { inherit fetchMaven; })
    mavenDoxiaSinkApi_1_0_alpha6
    mavenDoxiaSinkApi_1_0_alpha7
    mavenDoxiaSinkApi_1_0_alpha10;

  inherit (callPackage ../development/java-modules/maven/enforcer.nix { inherit fetchMaven; })
    mavenEnforcerApi_1_3_1
    mavenEnforcerRules_1_3_1;

  inherit (callPackage ../development/java-modules/maven/error-diagnostics.nix { inherit fetchMaven; })
    mavenErrorDiagnostics_2_0_1
    mavenErrorDiagnostics_2_0_6
    mavenErrorDiagnostics_2_0_9
    mavenErrorDiagnostics_2_2_1;

  inherit (callPackage ../development/java-modules/maven/filtering.nix { inherit fetchMaven; })
    mavenFiltering_1_1;

  inherit (callPackage ../development/java-modules/maven-hello { inherit mavenbuild; })
    mavenHello_1_0
    mavenHello_1_1;

  inherit (callPackage ../development/java-modules/maven/model.nix { inherit fetchMaven; })
    mavenModel_2_0_1
    mavenModel_2_0_6
    mavenModel_2_0_9
    mavenModel_2_2_1
    mavenModel_3_0_3;

  inherit (callPackage ../development/java-modules/maven/monitor.nix { inherit fetchMaven; })
    mavenMonitor_2_0_1
    mavenMonitor_2_0_6
    mavenMonitor_2_0_9
    mavenMonitor_2_2_1;

  inherit (callPackage ../development/java-modules/maven/plugin-annotations.nix { inherit fetchMaven; })
    mavenPluginAnnotations_3_1
    mavenPluginAnnotations_3_2;

  inherit (callPackage ../development/java-modules/maven/plugin-api.nix { inherit fetchMaven; })
    mavenPluginApi_2_0_1
    mavenPluginApi_2_0_6
    mavenPluginApi_2_0_9
    mavenPluginApi_2_2_1
    mavenPluginApi_3_0_3;

  inherit (callPackage ../development/java-modules/maven/plugin-descriptor.nix { inherit fetchMaven; })
    mavenPluginDescriptor_2_0_1
    mavenPluginDescriptor_2_0_6
    mavenPluginDescriptor_2_0_9
    mavenPluginDescriptor_2_2_1;

  inherit (callPackage ../development/java-modules/maven/plugin-parameter-documenter.nix { inherit fetchMaven; })
    mavenPluginParameterDocumenter_2_0_1
    mavenPluginParameterDocumenter_2_0_6
    mavenPluginParameterDocumenter_2_0_9
    mavenPluginParameterDocumenter_2_2_1;

  inherit (callPackage ../development/java-modules/maven/plugin-registry.nix { inherit fetchMaven; })
    mavenPluginRegistry_2_0_1
    mavenPluginRegistry_2_0_6
    mavenPluginRegistry_2_0_9
    mavenPluginRegistry_2_2_1;

  inherit (callPackage ../development/java-modules/maven/plugin-testing-harness.nix { inherit fetchMaven; })
    mavenPluginTestingHarness_1_1;

  inherit (callPackage ../development/java-modules/maven/profile.nix { inherit fetchMaven; })
    mavenProfile_2_0_1
    mavenProfile_2_0_6
    mavenProfile_2_0_9
    mavenProfile_2_2_1;

  inherit (callPackage ../development/java-modules/maven/project.nix { inherit fetchMaven; })
    mavenProject_2_0_1
    mavenProject_2_0_6
    mavenProject_2_0_8
    mavenProject_2_0_9
    mavenProject_2_2_1;

  inherit (callPackage ../development/java-modules/maven/reporting-api.nix { inherit fetchMaven; })
    mavenReportingApi_2_0_1
    mavenReportingApi_2_0_6
    mavenReportingApi_2_0_9
    mavenReportingApi_2_2_1;

  inherit (callPackage ../development/java-modules/maven/repository-metadata.nix { inherit fetchMaven; })
    mavenRepositoryMetadata_2_0_1
    mavenRepositoryMetadata_2_0_6
    mavenRepositoryMetadata_2_0_9
    mavenRepositoryMetadata_2_2_1;

  inherit (callPackage ../development/java-modules/maven/settings.nix { inherit fetchMaven; })
    mavenSettings_2_0_1
    mavenSettings_2_0_6
    mavenSettings_2_0_9
    mavenSettings_2_2_1;

  inherit (callPackage ../development/java-modules/maven/shared-incremental.nix { inherit fetchMaven; })
    mavenSharedIncremental_1_1;

  inherit (callPackage ../development/java-modules/maven/shared-utils.nix { inherit fetchMaven; })
    mavenSharedUtils_0_1;

  inherit (callPackage ../development/java-modules/maven/surefire-api.nix { inherit fetchMaven; })
    mavenSurefireApi_2_12_4
    mavenSurefireApi_2_17;

  inherit (callPackage ../development/java-modules/maven/surefire-booter.nix { inherit fetchMaven; })
    mavenSurefireBooter_2_12_4
    mavenSurefireBooter_2_17;

  inherit (callPackage ../development/java-modules/maven/surefire-common.nix { inherit fetchMaven; })
    mavenSurefireCommon_2_12_4
    mavenSurefireCommon_2_17;

  inherit (callPackage ../development/java-modules/maven/surefire-junit4.nix { inherit fetchMaven; })
    mavenSurefireJunit4_2_12_4;

  inherit (callPackage ../development/java-modules/maven/toolchain.nix { inherit fetchMaven; })
    mavenToolchain_1_0
    mavenToolchain_2_0_9
    mavenToolchain_2_2_1;

  inherit (callPackage ../development/java-modules/mojo/animal-sniffer.nix { inherit fetchMaven; })
    mojoAnimalSniffer_1_11;

  inherit (callPackage ../development/java-modules/mojo/java-boot-classpath-detector.nix { inherit fetchMaven; })
    mojoJavaBootClasspathDetector_1_11;

  inherit (callPackage ../development/java-modules/ow2/asm-all.nix { inherit fetchMaven; })
    ow2AsmAll_4_0;

  inherit (callPackage ../development/java-modules/plexus/archiver.nix { inherit fetchMaven; })
    plexusArchiver_1_0_alpha7
    plexusArchiver_2_1;

  inherit (callPackage ../development/java-modules/plexus/build-api.nix { inherit fetchMaven; })
    plexusBuildApi_0_0_4;

  inherit (callPackage ../development/java-modules/plexus/classworlds.nix { inherit fetchMaven; })
    plexusClassworlds_2_2_2
    plexusClassworlds_2_4;

  inherit (callPackage ../development/java-modules/plexus/compiler-api.nix { inherit fetchMaven; })
    plexusCompilerApi_2_2
    plexusCompilerApi_2_4;

  inherit (callPackage ../development/java-modules/plexus/compiler-javac.nix { inherit fetchMaven; })
    plexusCompilerJavac_2_2
    plexusCompilerJavac_2_4;

  inherit (callPackage ../development/java-modules/plexus/compiler-manager.nix { inherit fetchMaven; })
    plexusCompilerManager_2_2
    plexusCompilerManager_2_4;

  inherit (callPackage ../development/java-modules/plexus/component-annotations.nix { inherit fetchMaven; })
    plexusComponentAnnotations_1_5_5;

  inherit (callPackage ../development/java-modules/plexus/container-default.nix { inherit fetchMaven; })
    plexusContainerDefault_1_0_alpha9
    plexusContainerDefault_1_0_alpha9_stable1
    plexusContainerDefault_1_5_5;

  inherit (callPackage ../development/java-modules/plexus/digest.nix { inherit fetchMaven; })
    plexusDigest_1_0;

  inherit (callPackage ../development/java-modules/plexus/i18n.nix { inherit fetchMaven; })
    plexusI18n_1_0_beta6;

  inherit (callPackage ../development/java-modules/plexus/interactivity-api.nix { inherit fetchMaven; })
    plexusInteractivityApi_1_0_alpha4;

  inherit (callPackage ../development/java-modules/plexus/interpolation.nix { inherit fetchMaven; })
    plexusInterpolation_1_11
    plexusInterpolation_1_12
    plexusInterpolation_1_13
    plexusInterpolation_1_15;

  inherit (callPackage ../development/java-modules/plexus/io.nix { inherit fetchMaven; })
    plexusIo_2_0_2;

  inherit (callPackage ../development/java-modules/plexus/utils.nix { inherit fetchMaven; })
    plexusUtils_1_0_4
    plexusUtils_1_0_5
    plexusUtils_1_1
    plexusUtils_1_4_1
    plexusUtils_1_4_5
    plexusUtils_1_4_9
    plexusUtils_1_5_1
    plexusUtils_1_5_5
    plexusUtils_1_5_6
    plexusUtils_1_5_8
    plexusUtils_1_5_15
    plexusUtils_2_0_5
    plexusUtils_2_0_6
    plexusUtils_3_0
    plexusUtils_3_0_5
    plexusUtils_3_0_8;

  inherit (callPackage ../development/java-modules/sisu/guice.nix { inherit fetchMaven; })
    sisuGuice_2_9_4;

  inherit (callPackage ../development/java-modules/sisu/inject-bean.nix { inherit fetchMaven; })
    sisuInjectBean_2_1_1;

  inherit (callPackage ../development/java-modules/sisu/inject-plexus.nix { inherit fetchMaven; })
    sisuInjectPlexus_2_1_1;

  inherit (callPackage ../development/java-modules/apache/xbean-reflect.nix { inherit fetchMaven; })
    xbeanReflect_3_4;

  inherit (callPackage ../development/java-modules/xerces/impl.nix { inherit fetchMaven; })
    xercesImpl_2_8_0;

  inherit (callPackage ../development/java-modules/xml-apis { inherit fetchMaven; })
    xmlApis_1_3_03;
}
