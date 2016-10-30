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

  inherit (callPackage ../development/java-modules/beanshell/bsh.nix { inherit fetchMaven; })
    bsh_2_0_b4;

  inherit (callPackage ../development/java-modules/classworlds/classworlds.nix { inherit fetchMaven; })
    classworlds_1_1;

  inherit (callPackage ../development/java-modules/apache/commons-cli.nix { inherit fetchMaven; })
    commonsCli_1_0;

  inherit (callPackage ../development/java-modules/apache/commons-lang.nix { inherit fetchMaven; })
    commonsLang_2_3;

  inherit (callPackage ../development/java-modules/hamcrest/core.nix { inherit fetchMaven; })
    hamcrestCore_1_3;

  inherit (callPackage ../development/java-modules/junit { inherit mavenbuild; })
    junit_4_12;

  inherit (callPackage ../development/java-modules/maven/artifact.nix { inherit fetchMaven; })
    mavenArtifact_2_0_9
    mavenArtifact_3_0_3;

  inherit (callPackage ../development/java-modules/maven/artifact-manager.nix { inherit fetchMaven; })
    mavenArtifactManager_2_0_9;

  inherit (callPackage ../development/java-modules/maven/common-artifact-filters.nix { inherit fetchMaven; })
    mavenCommonArtifactFilters_1_4;

  inherit (callPackage ../development/java-modules/maven/core.nix { inherit fetchMaven; })
    mavenCore_2_0_9;

  inherit (callPackage ../development/java-modules/maven/dependency-tree.nix { inherit fetchMaven; })
    mavenDependencyTree_2_1;

  inherit (callPackage ../development/java-modules/maven/doxia-sink-api.nix { inherit fetchMaven; })
    mavenDoxiaSinkApi_1_0_alpha10;

  inherit (callPackage ../development/java-modules/maven/enforcer.nix { inherit fetchMaven; })
    mavenEnforcerApi_1_3_1
    mavenEnforcerRules_1_3_1;

  inherit (callPackage ../development/java-modules/maven/error-diagnostics.nix { inherit fetchMaven; })
    mavenErrorDiagnostics_2_0_9;

  inherit (callPackage ../development/java-modules/maven/model.nix { inherit fetchMaven; })
    mavenModel_2_0_9
    mavenModel_3_0_3;

  inherit (callPackage ../development/java-modules/maven/monitor.nix { inherit fetchMaven; })
    mavenMonitor_2_0_9;

  inherit (callPackage ../development/java-modules/maven/plugin-api.nix { inherit fetchMaven; })
    mavenPluginApi_2_0_6
    mavenPluginApi_2_0_9
    mavenPluginApi_3_0_3;

  inherit (callPackage ../development/java-modules/maven/plugin-descriptor.nix { inherit fetchMaven; })
    mavenPluginDescriptor_2_0_9;

  inherit (callPackage ../development/java-modules/maven/plugin-parameter-documenter.nix { inherit fetchMaven; })
    mavenPluginParameterDocumenter_2_0_9;

  inherit (callPackage ../development/java-modules/maven/plugin-registry.nix { inherit fetchMaven; })
    mavenPluginRegistry_2_0_9;

  inherit (callPackage ../development/java-modules/maven/profile.nix { inherit fetchMaven; })
    mavenProfile_2_0_9;

  inherit (callPackage ../development/java-modules/maven/project.nix { inherit fetchMaven; })
    mavenProject_2_0_9;

  inherit (callPackage ../development/java-modules/maven/reporting-api.nix { inherit fetchMaven; })
    mavenReportingApi_2_0_9;

  inherit (callPackage ../development/java-modules/maven/repository-metadata.nix { inherit fetchMaven; })
    mavenRepositoryMetadata_2_0_9;

  inherit (callPackage ../development/java-modules/maven/settings.nix { inherit fetchMaven; })
    mavenSettings_2_0_9;

  inherit (callPackage ../development/java-modules/plexus/component-annotations.nix { inherit fetchMaven; })
    plexusComponentAnnotations_1_5_5;

  inherit (callPackage ../development/java-modules/plexus/container-default.nix { inherit fetchMaven; })
    plexusContainerDefault_1_0_alpha9_stable1;

  inherit (callPackage ../development/java-modules/plexus/i18n.nix { inherit fetchMaven; })
    plexusI18n_1_0_beta6;

  inherit (callPackage ../development/java-modules/plexus/interactivity-api.nix { inherit fetchMaven; })
    plexusInteractivityApi_1_0_alpha4;

  inherit (callPackage ../development/java-modules/plexus/utils.nix { inherit fetchMaven; })
    plexusUtils_1_1
    plexusUtils_1_5_8
    plexusUtils_2_0_6
    plexusUtils_3_0;
}
