{ pkgs, stdenv, maven }:

with pkgs;

let
  mavenbuild = callPackage ../development/java-modules/build-maven-package.nix { };
  fetchMaven = callPackage ../development/java-modules/m2install.nix { };
in {
  inherit mavenbuild fetchMaven;

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
    plexusCompilerApi_2_2;

  inherit (callPackage ../development/java-modules/plexus/compiler-javac.nix { inherit fetchMaven; })
    plexusCompilerJavac_2_2;

  inherit (callPackage ../development/java-modules/plexus/compiler-manager.nix { inherit fetchMaven; })
    plexusCompilerManager_2_2;

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
