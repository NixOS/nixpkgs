{ stdenv, fetchurl }:
let mkJenkinsPlugin = { name, src }: stdenv.mkDerivation {
  name = name;
  src = src;
  phases = "installPhase";
  installPhase = ''
    mkdir $out
    cp $src $out
  '';
};
in rec {
  "AdaptivePlugin-0.1" = mkJenkinsPlugin {
    name = "AdaptivePlugin-0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/AdaptivePlugin/0.1/AdaptivePlugin.hpi";
      sha256 = "17ymch4pxa00n7bwwn092pwcpqgdsz1kwmpnz2hbjzhh1k56vhch";
    };
  };
  "AnchorChain-1.0" = mkJenkinsPlugin {
    name = "AnchorChain-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/AnchorChain/1.0/AnchorChain.hpi";
      sha256 = "0nvkirpcxmcycwd0m9bsn39990fmgsdjqld2sg76si1xnlbbjrcj";
    };
  };
  "ApicaLoadtest-1.9" = mkJenkinsPlugin {
    name = "ApicaLoadtest-1.9";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ApicaLoadtest/1.9/ApicaLoadtest.hpi";
      sha256 = "1zbv1fpj7hk7v05068zddbq3zr0vmc0v11cldx4lrzllmacgh0mr";
    };
  };
  "BlameSubversion-1.200" = mkJenkinsPlugin {
    name = "BlameSubversion-1.200";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/BlameSubversion/1.200/BlameSubversion.hpi";
      sha256 = "1jszkyfc3j9l06f413n1zx78gz7axdml5ifgcnpmg5dxj6cjpq5v";
    };
  };
  "BlazeMeterJenkinsPlugin-2.2.1" = mkJenkinsPlugin {
    name = "BlazeMeterJenkinsPlugin-2.2.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/BlazeMeterJenkinsPlugin/2.2.1/BlazeMeterJenkinsPlugin.hpi";
      sha256 = "1kpqp790c9jycwcq4dc9332f59gqkcxx4kdz52af3vk7km2yn24n";
    };
  };
  "CFLint-0.5.2" = mkJenkinsPlugin {
    name = "CFLint-0.5.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/CFLint/0.5.2/CFLint.hpi";
      sha256 = "1wz0zpq9ncq4c41049sd9fi6abd4iv1df9sqy8py0hg0hql54smk";
    };
  };
  "CustomHistory-1.6" = mkJenkinsPlugin {
    name = "CustomHistory-1.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/CustomHistory/1.6/CustomHistory.hpi";
      sha256 = "1rhgqgs46r1llnjhg60ydkfgl1yzcpq6jq5l4l7pgaq3fi7ba3xz";
    };
  };
  "DotCi-InstallPackages-1.2.0" = mkJenkinsPlugin {
    name = "DotCi-InstallPackages-1.2.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/DotCi-InstallPackages/1.2.0/DotCi-InstallPackages.hpi";
      sha256 = "0p8a8sk7kbfpps5fq9w4wjh1ycg967zikdxxmrcwfd1kpmpllsc0";
    };
  };
  "DotCi-Plugins-Starter-Pack-1.7.3" = mkJenkinsPlugin {
    name = "DotCi-Plugins-Starter-Pack-1.7.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/DotCi-Plugins-Starter-Pack/1.7.3/DotCi-Plugins-Starter-Pack.hpi";
      sha256 = "1fkrj3pm8l8cq64vmr76hnaqjfyw54n94gmyb7i3xhi56fmin293";
    };
  };
  "DotCi-2.28.0" = mkJenkinsPlugin {
    name = "DotCi-2.28.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/DotCi/2.28.0/DotCi.hpi";
      sha256 = "1fcj3hkaw2l9w8waiwihcds7zzlmk88g65r2r5xpawcy9265s6bj";
    };
  };
  "Exclusion-0.11" = mkJenkinsPlugin {
    name = "Exclusion-0.11";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/Exclusion/0.11/Exclusion.hpi";
      sha256 = "0az209x0d1g1qnlihrd2yr02f8lqkh7pq0dmlfbjkwiwq6zbav5p";
    };
  };
  "GatekeeperPlugin-3.0.5" = mkJenkinsPlugin {
    name = "GatekeeperPlugin-3.0.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/GatekeeperPlugin/3.0.5/GatekeeperPlugin.hpi";
      sha256 = "146vq8s7jkf27zqfzzd5j7xjvr7mgh87glyrzr6lp8fn1nlcpsf8";
    };
  };
  "JDK_Parameter_Plugin-1.0" = mkJenkinsPlugin {
    name = "JDK_Parameter_Plugin-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/JDK_Parameter_Plugin/1.0/JDK_Parameter_Plugin.hpi";
      sha256 = "0b94i10j5bg0la1r13d6slb2l4lj3sy42n2ql9zr6mqsamz324g1";
    };
  };
  "JiraTestResultReporter-1.0.4" = mkJenkinsPlugin {
    name = "JiraTestResultReporter-1.0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/JiraTestResultReporter/1.0.4/JiraTestResultReporter.hpi";
      sha256 = "19vklmpg33y6myzx2gsddjwzfcgbs3516y9gmpbi029pcfsw1lcl";
    };
  };
  "LavaLampNotifier-1.4" = mkJenkinsPlugin {
    name = "LavaLampNotifier-1.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/LavaLampNotifier/1.4/LavaLampNotifier.hpi";
      sha256 = "16px9gmp0hmf4mk1rgb79j1zbxf11cnhvjmci9ggxa8l5d7x80vf";
    };
  };
  "Matrix-sorter-plugin-1.1" = mkJenkinsPlugin {
    name = "Matrix-sorter-plugin-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/Matrix-sorter-plugin/1.1/Matrix-sorter-plugin.hpi";
      sha256 = "1bl4xv8sy6c4j2n66kqsmy9zalfqw75sidgggfrnjc2yjjrzkvyq";
    };
  };
  "NegotiateSSO-1.0" = mkJenkinsPlugin {
    name = "NegotiateSSO-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/NegotiateSSO/1.0/NegotiateSSO.hpi";
      sha256 = "1z0q0zpii0jjna79s1r6mncxmaxsah4b84wz70jry9hysi7mravi";
    };
  };
  "Parameterized-Remote-Trigger-2.2.2" = mkJenkinsPlugin {
    name = "Parameterized-Remote-Trigger-2.2.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/Parameterized-Remote-Trigger/2.2.2/Parameterized-Remote-Trigger.hpi";
      sha256 = "0vvd4bxakg5554wk1w9m9dl2052cix9s2d71ph3bz87008q2g7vd";
    };
  };
  "PrioritySorter-3.4" = mkJenkinsPlugin {
    name = "PrioritySorter-3.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/PrioritySorter/3.4/PrioritySorter.hpi";
      sha256 = "0pvhdywz4fcazw75qfkqc71z5mxsid6jdf7x96qnr9vzgsy5vcjj";
    };
  };
  "SBuild-1.0.2" = mkJenkinsPlugin {
    name = "SBuild-1.0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/SBuild/1.0.2/SBuild.hpi";
      sha256 = "1x59s3qyav7rv3krlsa168mq934vvg68ch4n3lkkq1fxrs015yr3";
    };
  };
  "SCTMExecutor-1.5.1" = mkJenkinsPlugin {
    name = "SCTMExecutor-1.5.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/SCTMExecutor/1.5.1/SCTMExecutor.hpi";
      sha256 = "1p59kkj33pbf4g1dy0w098fac06dl3vl41sx660ijh0d4zzc065s";
    };
  };
  "Schmant-1.1.4" = mkJenkinsPlugin {
    name = "Schmant-1.1.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/Schmant/1.1.4/Schmant.hpi";
      sha256 = "0vlqbbazrjhnl06kpg8rjg0102gyhiypwd3s70l2q87s03pr0q1m";
    };
  };
  "StashBranchParameter-0.2.0" = mkJenkinsPlugin {
    name = "StashBranchParameter-0.2.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/StashBranchParameter/0.2.0/StashBranchParameter.hpi";
      sha256 = "1yz416cpw9yphlc4dn4y4qydbs9c020idr6snygjn8asay0lq8ni";
    };
  };
  "Surround-SCM-plugin-1.7" = mkJenkinsPlugin {
    name = "Surround-SCM-plugin-1.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/Surround-SCM-plugin/1.7/Surround-SCM-plugin.hpi";
      sha256 = "058pg77d6q4hwl9fz05ch25bp3w6hwbk5v94d5ril88nh03wnwnk";
    };
  };
  "TestComplete-1.3" = mkJenkinsPlugin {
    name = "TestComplete-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/TestComplete/1.3/TestComplete.hpi";
      sha256 = "1n72lrx1lrfgd6hqcx2kdh80vawgn2zdzfwmcwi3v7plb08z6y76";
    };
  };
  "TestFairy-3.0" = mkJenkinsPlugin {
    name = "TestFairy-3.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/TestFairy/3.0/TestFairy.hpi";
      sha256 = "0ix1ffj2qvijs9l75cddqnkpl4dza4gvj53qp62ldv4q5byaibhw";
    };
  };
  "TwilioNotifier-0.2.1" = mkJenkinsPlugin {
    name = "TwilioNotifier-0.2.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/TwilioNotifier/0.2.1/TwilioNotifier.hpi";
      sha256 = "1gj5fzbafpqnm8bz0jwjz15vzvq31vjr801yyvjrymgsfxwx75rg";
    };
  };
  "URLSCM-1.6" = mkJenkinsPlugin {
    name = "URLSCM-1.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/URLSCM/1.6/URLSCM.hpi";
      sha256 = "1bxx04nw1a06y2ckbv5igcar9mg67d067q7j40nww9am5qh2324i";
    };
  };
  "WebSVN2-0.9" = mkJenkinsPlugin {
    name = "WebSVN2-0.9";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/WebSVN2/0.9/WebSVN2.hpi";
      sha256 = "0hacngbzzm7rqg9f0x9v5i79isjlyj52r3clq4551kmfb54yq470";
    };
  };
  "accelerated-build-now-plugin-1.0.1" = mkJenkinsPlugin {
    name = "accelerated-build-now-plugin-1.0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/accelerated-build-now-plugin/1.0.1/accelerated-build-now-plugin.hpi";
      sha256 = "04vmpvhpr1fh1afx2ipbrhlnyzwdf0ld3mkyjxva47g9jfipvqq1";
    };
  };
  "accurev-0.6.35" = mkJenkinsPlugin {
    name = "accurev-0.6.35";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/accurev/0.6.35/accurev.hpi";
      sha256 = "153c609wmw2x2y4vncr64hcblzmmfhhy9zniy03nlpxxdxdpq6n3";
    };
  };
  "ace-editor-1.0.1" = mkJenkinsPlugin {
    name = "ace-editor-1.0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ace-editor/1.0.1/ace-editor.hpi";
      sha256 = "0n5y29s0010d8dfpi2v1yr29w58839ia0xhwrlldnz3pda8d4qfr";
    };
  };
  "active-directory-1.41" = mkJenkinsPlugin {
    name = "active-directory-1.41";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/active-directory/1.41/active-directory.hpi";
      sha256 = "1laaq3bbkiyyrbj4fym1v2ghz2iw85d5lkfl04ikmxch2cczg89r";
    };
  };
  "adaptive-disconnector-0.2" = mkJenkinsPlugin {
    name = "adaptive-disconnector-0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/adaptive-disconnector/0.2/adaptive-disconnector.hpi";
      sha256 = "15gg5kdvf1k20p2ypi7a3zf97i1gb4vazwm2mnjlcm0ybgwqfqdv";
    };
  };
  "additional-identities-plugin-1.1" = mkJenkinsPlugin {
    name = "additional-identities-plugin-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/additional-identities-plugin/1.1/additional-identities-plugin.hpi";
      sha256 = "0xjzkbpa1izhf0gwbmgikw0xy178ssff22h77w0dcy2kmf4hcfn1";
    };
  };
  "advanced-installer-msi-builder-1.3" = mkJenkinsPlugin {
    name = "advanced-installer-msi-builder-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/advanced-installer-msi-builder/1.3/advanced-installer-msi-builder.hpi";
      sha256 = "0ppaasbynhinw50vyxsd4kfxxyq7hwx7dpwaqr7867hryyqhfs9y";
    };
  };
  "all-changes-1.3" = mkJenkinsPlugin {
    name = "all-changes-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/all-changes/1.3/all-changes.hpi";
      sha256 = "0yr5hc35ipd5z3myx4sn2s36mdizj5n17s72z55pwf1fkpdmnrjp";
    };
  };
  "allure-jenkins-plugin-2.10" = mkJenkinsPlugin {
    name = "allure-jenkins-plugin-2.10";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/allure-jenkins-plugin/2.10/allure-jenkins-plugin.hpi";
      sha256 = "1kbkl0349a7nip9ibr8b2z45qdgyn77z1vdm7a3y7a3llym0szc4";
    };
  };
  "amazon-ecr-1.0" = mkJenkinsPlugin {
    name = "amazon-ecr-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/amazon-ecr/1.0/amazon-ecr.hpi";
      sha256 = "1kmq9xyh35kcw1g73km6ppdkch5yl4qlac9isdbim3h2p8jbx2zx";
    };
  };
  "amazon-ecs-1.2" = mkJenkinsPlugin {
    name = "amazon-ecs-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/amazon-ecs/1.2/amazon-ecs.hpi";
      sha256 = "0wjqd9w11id5ygk6zf5bznw5dq1489ml1f020lxw2pqp3l9kgnns";
    };
  };
  "analysis-collector-1.46" = mkJenkinsPlugin {
    name = "analysis-collector-1.46";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/analysis-collector/1.46/analysis-collector.hpi";
      sha256 = "0jx83yr5dy83b3h6p7wg24h5rshzkalwcv7l20bxywapm2vnv6nr";
    };
  };
  "analysis-core-1.75" = mkJenkinsPlugin {
    name = "analysis-core-1.75";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/analysis-core/1.75/analysis-core.hpi";
      sha256 = "1wl8q585n1jdcd2i9bj3ikjfb5hs3dx0ag264xfakdxmlzbkazlr";
    };
  };
  "android-emulator-2.13.1" = mkJenkinsPlugin {
    name = "android-emulator-2.13.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/android-emulator/2.13.1/android-emulator.hpi";
      sha256 = "04431xyhz4f17pa4qldkc5drn7049j340q8my68i6f903bzz02b2";
    };
  };
  "android-lint-2.2" = mkJenkinsPlugin {
    name = "android-lint-2.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/android-lint/2.2/android-lint.hpi";
      sha256 = "0dd1dssb5d1dr5jq3mw7w2npap1m4vf335gh5k6y12cl04m071gv";
    };
  };
  "ansible-0.4" = mkJenkinsPlugin {
    name = "ansible-0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ansible/0.4/ansible.hpi";
      sha256 = "16mfpsk5hj30l2hr4hgy7bq4yljhhr5kgcgny941gq3l5b4i3mhy";
    };
  };
  "ansicolor-0.4.2" = mkJenkinsPlugin {
    name = "ansicolor-0.4.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ansicolor/0.4.2/ansicolor.hpi";
      sha256 = "0hiw4wirg2a3gyw5kjgd156azhgi4j4ipn3skzns3xb4f47k2yzh";
    };
  };
  "ant-1.2" = mkJenkinsPlugin {
    name = "ant-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ant/1.2/ant.hpi";
      sha256 = "12xcslfji5br0z375dfwix74qkv88qrxx0njag6q825sq261jmhg";
    };
  };
  "antexec-1.11" = mkJenkinsPlugin {
    name = "antexec-1.11";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/antexec/1.11/antexec.hpi";
      sha256 = "0p8mf0znxvb3fz9m1nx5mdxgvp4ap908wqwwpr9zbq5krcdh2n98";
    };
  };
  "antisamy-markup-formatter-1.3" = mkJenkinsPlugin {
    name = "antisamy-markup-formatter-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/antisamy-markup-formatter/1.3/antisamy-markup-formatter.hpi";
      sha256 = "00q4wgy8y3dp126haix5vjszfkfyf4l49rvs916p6cdl53f4ycq8";
    };
  };
  "any-buildstep-0.1" = mkJenkinsPlugin {
    name = "any-buildstep-0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/any-buildstep/0.1/any-buildstep.hpi";
      sha256 = "1yncn3d2lwd0y7g4fkv9qkf2xrpv7q5ih3rdansdx7210k8w4qls";
    };
  };
  "anything-goes-formatter-1.0" = mkJenkinsPlugin {
    name = "anything-goes-formatter-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/anything-goes-formatter/1.0/anything-goes-formatter.hpi";
      sha256 = "1xk0r75gg1nnpjgi9ph586rr8sbdq8rzw622r3l71wmrn2pcmypi";
    };
  };
  "appaloosa-plugin-1.4.2" = mkJenkinsPlugin {
    name = "appaloosa-plugin-1.4.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/appaloosa-plugin/1.4.2/appaloosa-plugin.hpi";
      sha256 = "16knx1fdjwg42hwxgfim0ihxxv483j5r6zdskhcpg52p3j481fz1";
    };
  };
  "appdynamics-dashboard-1.0.7" = mkJenkinsPlugin {
    name = "appdynamics-dashboard-1.0.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/appdynamics-dashboard/1.0.7/appdynamics-dashboard.hpi";
      sha256 = "022qjfifm58f8c7hsyz81iax850zl08s59q1qyyifn69jzhjqqfy";
    };
  };
  "appetize-1.1.0" = mkJenkinsPlugin {
    name = "appetize-1.1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/appetize/1.1.0/appetize.hpi";
      sha256 = "01azx2fgii088hbym5g3df46ynjcv1i9n7bbax0fyx6b32gsr2gr";
    };
  };
  "appio-1.3" = mkJenkinsPlugin {
    name = "appio-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/appio/1.3/appio.hpi";
      sha256 = "15yg47snxjzh5i80872hfw6y2ibhaia5xcf7xr41sxqj48kn9hkn";
    };
  };
  "application-director-plugin-1.3" = mkJenkinsPlugin {
    name = "application-director-plugin-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/application-director-plugin/1.3/application-director-plugin.hpi";
      sha256 = "0zqp23x0qqban5acglf1hia350m1v8ilp0d00m540ixw5n4l0f5r";
    };
  };
  "archived-artifact-url-viewer-1.1" = mkJenkinsPlugin {
    name = "archived-artifact-url-viewer-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/archived-artifact-url-viewer/1.1/archived-artifact-url-viewer.hpi";
      sha256 = "1glq8wizsvdsjkjhih40qgzwaskmw4wargp5zinxhhjiqvcnrcwv";
    };
  };
  "artifact-diff-plugin-1.3" = mkJenkinsPlugin {
    name = "artifact-diff-plugin-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/artifact-diff-plugin/1.3/artifact-diff-plugin.hpi";
      sha256 = "1pggqrlkcpwnc1wxjc63ggc2n09b0q11z5s4nww48lmfyz06h9a6";
    };
  };
  "artifact-promotion-0.4.0" = mkJenkinsPlugin {
    name = "artifact-promotion-0.4.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/artifact-promotion/0.4.0/artifact-promotion.hpi";
      sha256 = "1hqnh3iy4nphmwqy5bbpf87ms45dsnr6k5772wbjcwxi79vnr5f6";
    };
  };
  "artifactdeployer-0.33" = mkJenkinsPlugin {
    name = "artifactdeployer-0.33";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/artifactdeployer/0.33/artifactdeployer.hpi";
      sha256 = "0vxm7vfykcp684iq698vm2dqq6a212rclq8fp6wcsxn2kc8xml2b";
    };
  };
  "artifactory-2.4.7" = mkJenkinsPlugin {
    name = "artifactory-2.4.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/artifactory/2.4.7/artifactory.hpi";
      sha256 = "10yrpqc4h53piq64qshn02k486qc9a3c8q47f7yrzaxanl1l2r83";
    };
  };
  "asakusa-satellite-plugin-0.1.1" = mkJenkinsPlugin {
    name = "asakusa-satellite-plugin-0.1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/asakusa-satellite-plugin/0.1.1/asakusa-satellite-plugin.hpi";
      sha256 = "0v7wnp2w6nkd5p6h33lmn42l015bhixq16ncvk1jkyln3dh0xa9p";
    };
  };
  "assembla-auth-1.06" = mkJenkinsPlugin {
    name = "assembla-auth-1.06";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/assembla-auth/1.06/assembla-auth.hpi";
      sha256 = "055m2fpqdw28av443barvs42i9gkad1xzm6fgfbcqjs085zn92b0";
    };
  };
  "assembla-1.4" = mkJenkinsPlugin {
    name = "assembla-1.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/assembla/1.4/assembla.hpi";
      sha256 = "09p76n01pi555d2wig5ilf57nma09kl807xgnbkalp28k9c76g1w";
    };
  };
  "associated-files-0.2.1" = mkJenkinsPlugin {
    name = "associated-files-0.2.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/associated-files/0.2.1/associated-files.hpi";
      sha256 = "0x1gvdlkw00k9zlq4pa5nvvpfz2xy61kmhnwgv8827rrnrx4whpj";
    };
  };
  "async-http-client-1.7.24" = mkJenkinsPlugin {
    name = "async-http-client-1.7.24";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/async-http-client/1.7.24/async-http-client.hpi";
      sha256 = "0p18y02q11gkx21bpndl25y07wlxzc637hh46zsrrciix4a2r99v";
    };
  };
  "async-job-1.3" = mkJenkinsPlugin {
    name = "async-job-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/async-job/1.3/async-job.hpi";
      sha256 = "12w9nv9danrgarjag7xz9zc35ca5mn7idlk0dkcvnc3wz6gnrhv9";
    };
  };
  "attention-1.1" = mkJenkinsPlugin {
    name = "attention-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/attention/1.1/attention.hpi";
      sha256 = "1kjf5avpfjvaaflp7d4jadmb3rdfglini8hj03g8v9cs8dny3kjr";
    };
  };
  "audit-trail-2.2" = mkJenkinsPlugin {
    name = "audit-trail-2.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/audit-trail/2.2/audit-trail.hpi";
      sha256 = "0yb1mjmdvfqh8gf16wg36qrz95xd4h5xjldp50nr8z4ds5b7kzzi";
    };
  };
  "audit2db-0.5" = mkJenkinsPlugin {
    name = "audit2db-0.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/audit2db/0.5/audit2db.hpi";
      sha256 = "10x7xmg0mkqp42k25qf2cihpq8ckai9y634cjs3nnl7dbnk3059a";
    };
  };
  "authentication-tokens-1.2" = mkJenkinsPlugin {
    name = "authentication-tokens-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/authentication-tokens/1.2/authentication-tokens.hpi";
      sha256 = "1vklvapnd0yfj2mn3lj9s0dhb1n3mq3fgmfhrs4svbkihy0w972j";
    };
  };
  "authorize-project-1.1.0" = mkJenkinsPlugin {
    name = "authorize-project-1.1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/authorize-project/1.1.0/authorize-project.hpi";
      sha256 = "1bh0sl6c5iyika912p2aqv3ydr1s7hw26xs5fa46fkqs6mk1nbgn";
    };
  };
  "avatar-1.2" = mkJenkinsPlugin {
    name = "avatar-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/avatar/1.2/avatar.hpi";
      sha256 = "0schzzdl23llriwpdbdqf0825yigxlkq4mjr2wkyzhfgdkm5is4x";
    };
  };
  "aws-beanstalk-publisher-plugin-1.5.6" = mkJenkinsPlugin {
    name = "aws-beanstalk-publisher-plugin-1.5.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/aws-beanstalk-publisher-plugin/1.5.6/aws-beanstalk-publisher-plugin.hpi";
      sha256 = "0wbc313zxls29bpv50kd5zzm430h708hfnw08jp298m2h4adhir7";
    };
  };
  "aws-codepipeline-0.11" = mkJenkinsPlugin {
    name = "aws-codepipeline-0.11";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/aws-codepipeline/0.11/aws-codepipeline.hpi";
      sha256 = "11pimdp05bap6g5wd2gbrjb05khgrg08xqndl3l9gigr1wsq7jcj";
    };
  };
  "aws-credentials-1.11" = mkJenkinsPlugin {
    name = "aws-credentials-1.11";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/aws-credentials/1.11/aws-credentials.hpi";
      sha256 = "0az54pi7qssv7l5p0abg5rjh07b3y7v0nfil9h8q94gc82g1123y";
    };
  };
  "aws-device-farm-1.11" = mkJenkinsPlugin {
    name = "aws-device-farm-1.11";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/aws-device-farm/1.11/aws-device-farm.hpi";
      sha256 = "0vhqkr2bf24qfmm6h591r0vxwcm12fygd0c4rfshyjjvbvsw0p23";
    };
  };
  "aws-java-sdk-1.10.45" = mkJenkinsPlugin {
    name = "aws-java-sdk-1.10.45";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/aws-java-sdk/1.10.45/aws-java-sdk.hpi";
      sha256 = "1x2k0y20yfr2fnzsfvglman5rn3gpz90w10ap0h7kqm4aqmlhx2k";
    };
  };
  "aws-lambda-0.4.0" = mkJenkinsPlugin {
    name = "aws-lambda-0.4.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/aws-lambda/0.4.0/aws-lambda.hpi";
      sha256 = "11qbzhcd9ibaws7jdyznw1rqd22fm0w3xxzcbchrl3gsn7qyld50";
    };
  };
  "awseb-deployment-plugin-0.3.5" = mkJenkinsPlugin {
    name = "awseb-deployment-plugin-0.3.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/awseb-deployment-plugin/0.3.5/awseb-deployment-plugin.hpi";
      sha256 = "0cicf8h762mzzrp11ib4wsy0s0sp9cmg4q15ql0zh42air5bqsa4";
    };
  };
  "azure-publishersettings-credentials-1.1" = mkJenkinsPlugin {
    name = "azure-publishersettings-credentials-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/azure-publishersettings-credentials/1.1/azure-publishersettings-credentials.hpi";
      sha256 = "11micksn8ca1gkngwm5plvhvd1340wzhxsyij836glpld2j5j97b";
    };
  };
  "azure-slave-plugin-0.3.3" = mkJenkinsPlugin {
    name = "azure-slave-plugin-0.3.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/azure-slave-plugin/0.3.3/azure-slave-plugin.hpi";
      sha256 = "1zgd4ml9pcxiflx5cgjzv72k8s9idy85chvwpmjqkpa4cv510d8b";
    };
  };
  "backlog-1.11" = mkJenkinsPlugin {
    name = "backlog-1.11";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/backlog/1.11/backlog.hpi";
      sha256 = "01gl832g6ychqhk4djl2vrq3vqvk5yv4q4qfs2aw12ban066m1r9";
    };
  };
  "backup-interrupt-plugin-1.0" = mkJenkinsPlugin {
    name = "backup-interrupt-plugin-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/backup-interrupt-plugin/1.0/backup-interrupt-plugin.hpi";
      sha256 = "06chhpcjjk2f5za4nj0kpmhl9a7gwgmpi31g1xjpnm3y80ijzr1p";
    };
  };
  "backup-1.6.1" = mkJenkinsPlugin {
    name = "backup-1.6.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/backup/1.6.1/backup.hpi";
      sha256 = "0hirg1zm6rjaq304ha13gk6fnrajwrn9s8ysx6bpfrv230ni9qvp";
    };
  };
  "bamboo-notifier-1.1" = mkJenkinsPlugin {
    name = "bamboo-notifier-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/bamboo-notifier/1.1/bamboo-notifier.hpi";
      sha256 = "0n1s89llld3sh058y5bbc93qmvkk1lqbznw4h3k8218a61kar4bl";
    };
  };
  "batch-task-1.17" = mkJenkinsPlugin {
    name = "batch-task-1.17";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/batch-task/1.17/batch-task.hpi";
      sha256 = "0maivnv3jx8xmykk6qrdcjm2p7xwkpkivnaw0hhi5pbi44zxw81c";
    };
  };
  "bazaar-1.22" = mkJenkinsPlugin {
    name = "bazaar-1.22";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/bazaar/1.22/bazaar.hpi";
      sha256 = "0ha1spj84963xzax3gsaz72hhs9pxv79gy7cax16jakfr63hkzyp";
    };
  };
  "bds-plugin-3.1" = mkJenkinsPlugin {
    name = "bds-plugin-3.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/bds-plugin/3.1/bds-plugin.hpi";
      sha256 = "15r6qrahayp86vhvfri4hqinzm5vnnjlk329d5kfig8n6rhvij6y";
    };
  };
  "beaker-builder-1.8" = mkJenkinsPlugin {
    name = "beaker-builder-1.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/beaker-builder/1.8/beaker-builder.hpi";
      sha256 = "09r3rn0r4qm8wdk115mfzd7wpnqdbxa8zbhq6ym97cl0kh38n9rn";
    };
  };
  "bearychat-2.0" = mkJenkinsPlugin {
    name = "bearychat-2.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/bearychat/2.0/bearychat.hpi";
      sha256 = "060mq3rig07xv9i8jcaz2g2mjbx9izfm40wqq4b3a111jn6619ck";
    };
  };
  "beer-1.2" = mkJenkinsPlugin {
    name = "beer-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/beer/1.2/beer.hpi";
      sha256 = "189vxmp4s3rmh21r6nnpgsya3ml4n60xwqcy7lwlx4fn7hj8x17n";
    };
  };
  "bigpanda-jenkins-1.1" = mkJenkinsPlugin {
    name = "bigpanda-jenkins-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/bigpanda-jenkins/1.1/bigpanda-jenkins.hpi";
      sha256 = "0pnbszb495vgn83kfnbm2jnh1c13d1h111svmj5q0bghmid0zb3q";
    };
  };
  "bitbucket-approve-1.0.3" = mkJenkinsPlugin {
    name = "bitbucket-approve-1.0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/bitbucket-approve/1.0.3/bitbucket-approve.hpi";
      sha256 = "16ssjfz5kvnxbjvbn17xsa5lwg13va44cir8yxxb95cfrzmf8zi5";
    };
  };
  "bitbucket-build-status-notifier-1.0.3" = mkJenkinsPlugin {
    name = "bitbucket-build-status-notifier-1.0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/bitbucket-build-status-notifier/1.0.3/bitbucket-build-status-notifier.hpi";
      sha256 = "0hqngpwqk6paw221ac732qp7y4shn9nqb7dsflm83xwjkwkzncbh";
    };
  };
  "bitbucket-oauth-0.4" = mkJenkinsPlugin {
    name = "bitbucket-oauth-0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/bitbucket-oauth/0.4/bitbucket-oauth.hpi";
      sha256 = "07k9nbkjvy4y4gqazj2i1yc7xwpl7gr79ikxfn7gp56cdkg91w82";
    };
  };
  "bitbucket-pullrequest-builder-1.4.13" = mkJenkinsPlugin {
    name = "bitbucket-pullrequest-builder-1.4.13";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/bitbucket-pullrequest-builder/1.4.13/bitbucket-pullrequest-builder.hpi";
      sha256 = "1qcfghlhrbivb99pjv047vhq597livb16dky0x4gqab6d08jc843";
    };
  };
  "bitbucket-1.1.5" = mkJenkinsPlugin {
    name = "bitbucket-1.1.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/bitbucket/1.1.5/bitbucket.hpi";
      sha256 = "0n7wrz30689l6zszd5bl1kppski3y5fd4i6idw24hifxpv0aiy4c";
    };
  };
  "bitkeeper-1.8" = mkJenkinsPlugin {
    name = "bitkeeper-1.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/bitkeeper/1.8/bitkeeper.hpi";
      sha256 = "1vpnpg8fhddyma8wkx0i8nn5b0fpf43sfnz3q3dhakqbxfqc7vwx";
    };
  };
  "blackduck-installer-1.0.2" = mkJenkinsPlugin {
    name = "blackduck-installer-1.0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/blackduck-installer/1.0.2/blackduck-installer.hpi";
      sha256 = "1wnssqfbcxm89fjbsfj0iisy2ixyqxvs1zpq3mca50s68zn22q43";
    };
  };
  "blame-upstream-commiters-1.2" = mkJenkinsPlugin {
    name = "blame-upstream-commiters-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/blame-upstream-commiters/1.2/blame-upstream-commiters.hpi";
      sha256 = "1rx006067zcd1hgcmrvq8ykjxy8rqgsk8v9nqv39yq3nijpz5sw4";
    };
  };
  "blink1-1.1" = mkJenkinsPlugin {
    name = "blink1-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/blink1/1.1/blink1.hpi";
      sha256 = "06vk7783wh4b2kwl2ggwbqlwaqajkdpr3lc99czvz6254cq4b5y0";
    };
  };
  "blitz_io-jenkins-1.04" = mkJenkinsPlugin {
    name = "blitz_io-jenkins-1.04";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/blitz_io-jenkins/1.04/blitz_io-jenkins.hpi";
      sha256 = "0ryaixslknpd4yy1vazq8i4mr7rx2fsdx0rkx3w4a2by5kbyf80l";
    };
  };
  "block-queued-job-0.2.0" = mkJenkinsPlugin {
    name = "block-queued-job-0.2.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/block-queued-job/0.2.0/block-queued-job.hpi";
      sha256 = "008dfk2dh2n8sbqp02fx0cir4cmzpvnzkqlrn2z7fzblbbgr4vql";
    };
  };
  "bootstrap-1.3.1" = mkJenkinsPlugin {
    name = "bootstrap-1.3.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/bootstrap/1.3.1/bootstrap.hpi";
      sha256 = "1xrm6gid9nmnv4dr0nv6bswz0sgv4vipc43sdb7kgsc9jmgw5nz4";
    };
  };
  "bootstraped-multi-test-results-report-1.4.6" = mkJenkinsPlugin {
    name = "bootstraped-multi-test-results-report-1.4.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/bootstraped-multi-test-results-report/1.4.6/bootstraped-multi-test-results-report.hpi";
      sha256 = "0njmgyb0x5bm69zrpq6wjc5pvdbr2c9y94gi9iypy943pknmf4m6";
    };
  };
  "brakeman-0.7" = mkJenkinsPlugin {
    name = "brakeman-0.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/brakeman/0.7/brakeman.hpi";
      sha256 = "0qikfdkfckccqcpj6akqfbxr4sv6n704nd4srlz7ghc23vr1c5kk";
    };
  };
  "branch-api-1.1" = mkJenkinsPlugin {
    name = "branch-api-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/branch-api/1.1/branch-api.hpi";
      sha256 = "13vrpza4z4av4g6x2fjiq3v9byafhqsz1vvz7340q9g0h0f7yq0y";
    };
  };
  "browser-axis-plugin-1.0" = mkJenkinsPlugin {
    name = "browser-axis-plugin-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/browser-axis-plugin/1.0/browser-axis-plugin.hpi";
      sha256 = "098ssvkhallaglq3xbnjzam4jkmiz2b4ax5bwfl2im556vzjnv6h";
    };
  };
  "bruceschneier-0.1" = mkJenkinsPlugin {
    name = "bruceschneier-0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/bruceschneier/0.1/bruceschneier.hpi";
      sha256 = "0limhsdmkm6x24bbnwzhig53h6wsc49piampz3az51l5mlif1v9y";
    };
  };
  "buckminster-1.1.1" = mkJenkinsPlugin {
    name = "buckminster-1.1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/buckminster/1.1.1/buckminster.hpi";
      sha256 = "1fqvn2pmzpwqsl72wa4lyr21v76krf9sdv2fss2j1bwg5zay33y5";
    };
  };
  "buddycloud-0.3.0" = mkJenkinsPlugin {
    name = "buddycloud-0.3.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/buddycloud/0.3.0/buddycloud.hpi";
      sha256 = "1ks1b9r8abprhfynixffsl1qsrl2as9ia6nbmady2wwq2dq97z78";
    };
  };
  "bugzilla-1.5" = mkJenkinsPlugin {
    name = "bugzilla-1.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/bugzilla/1.5/bugzilla.hpi";
      sha256 = "1z9dm3x2p89jpyvsy29mm7796212992gf2d8w9066g3dpi7fvg1y";
    };
  };
  "build-alias-setter-0.4" = mkJenkinsPlugin {
    name = "build-alias-setter-0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/build-alias-setter/0.4/build-alias-setter.hpi";
      sha256 = "0sf20i81s6iq3mq30g1nrxfp7w7xv56dp992ylspqzjq05bqff2q";
    };
  };
  "build-blocker-plugin-1.7.3" = mkJenkinsPlugin {
    name = "build-blocker-plugin-1.7.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/build-blocker-plugin/1.7.3/build-blocker-plugin.hpi";
      sha256 = "1ngivbdi0bzh48s5c4wz9z2kj74a011zawmimsnrvfaf5fmlg69d";
    };
  };
  "build-cause-run-condition-0.1" = mkJenkinsPlugin {
    name = "build-cause-run-condition-0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/build-cause-run-condition/0.1/build-cause-run-condition.hpi";
      sha256 = "08a1b4wf7z5k3vv5zkcsskf4mqsqv66nr3a2gd6nzqhgnf0k4x8v";
    };
  };
  "build-env-propagator-1.0" = mkJenkinsPlugin {
    name = "build-env-propagator-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/build-env-propagator/1.0/build-env-propagator.hpi";
      sha256 = "0rlwgdzmsdkim09sx4cxiffg79w3g7ckb4r2dfia03hxkkdz8n53";
    };
  };
  "build-environment-1.6" = mkJenkinsPlugin {
    name = "build-environment-1.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/build-environment/1.6/build-environment.hpi";
      sha256 = "1g5vy6cyc6xq8gd4wnndvfhw4379903f3fh9aj9wdfgj8k397932";
    };
  };
  "build-failure-analyzer-1.13.3" = mkJenkinsPlugin {
    name = "build-failure-analyzer-1.13.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/build-failure-analyzer/1.13.3/build-failure-analyzer.hpi";
      sha256 = "0bm60wdgwnbmq25g0av2mnn97abajs9rgjclmxzhjlf0zkxgxixc";
    };
  };
  "build-flow-extensions-plugin-0.1.1" = mkJenkinsPlugin {
    name = "build-flow-extensions-plugin-0.1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/build-flow-extensions-plugin/0.1.1/build-flow-extensions-plugin.hpi";
      sha256 = "1nyggz8psgg75d68gsqrkf2sfnbnmqr9423ga9ksx7kmpcyqh8i6";
    };
  };
  "build-flow-plugin-0.18" = mkJenkinsPlugin {
    name = "build-flow-plugin-0.18";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/build-flow-plugin/0.18/build-flow-plugin.hpi";
      sha256 = "0g63ni2w347cggbz11x35nq17zavqifymjarpy102bc0i8sc36qr";
    };
  };
  "build-flow-test-aggregator-1.2" = mkJenkinsPlugin {
    name = "build-flow-test-aggregator-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/build-flow-test-aggregator/1.2/build-flow-test-aggregator.hpi";
      sha256 = "10bnyl9l6g2qc1ggnh3qqsvvscps0hagfnqymrg10277nr0j8r9z";
    };
  };
  "build-history-metrics-plugin-1.2" = mkJenkinsPlugin {
    name = "build-history-metrics-plugin-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/build-history-metrics-plugin/1.2/build-history-metrics-plugin.hpi";
      sha256 = "1wn0w7ax0fipdfmydrymlq1j1dwf0i6phi3xhyzxghpz68ihxv8b";
    };
  };
  "build-keeper-plugin-1.3" = mkJenkinsPlugin {
    name = "build-keeper-plugin-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/build-keeper-plugin/1.3/build-keeper-plugin.hpi";
      sha256 = "0jv49h5i058c2z7ma184lmhslkghsni42mqr1ll1rcnp67s6gpbl";
    };
  };
  "build-line-1.0.4" = mkJenkinsPlugin {
    name = "build-line-1.0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/build-line/1.0.4/build-line.hpi";
      sha256 = "048ifp33v7azkvd6nk0lhxdpn5b6231c076wvg564j14sb3dljp8";
    };
  };
  "build-metrics-1.0" = mkJenkinsPlugin {
    name = "build-metrics-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/build-metrics/1.0/build-metrics.hpi";
      sha256 = "0b7446lml4g6yhv9z7q12gdz09b9v7ry22rvznpnnf75qa86j0gi";
    };
  };
  "build-monitor-plugin-1.8+build.201601112328" = mkJenkinsPlugin {
    name = "build-monitor-plugin-1.8+build.201601112328";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/build-monitor-plugin/1.8+build.201601112328/build-monitor-plugin.hpi";
      sha256 = "0qdazq4dskmwgk2a5q595ywdhxk42d1z6hkh6wr43y0m8zavgwx9";
    };
  };
  "build-name-setter-1.5.1" = mkJenkinsPlugin {
    name = "build-name-setter-1.5.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/build-name-setter/1.5.1/build-name-setter.hpi";
      sha256 = "1bwymy6dsn57vs9p6qkfcw4nvi48fwkfm9bh8zgjqwywg6f6cfy6";
    };
  };
  "build-pipeline-plugin-1.4.9" = mkJenkinsPlugin {
    name = "build-pipeline-plugin-1.4.9";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/build-pipeline-plugin/1.4.9/build-pipeline-plugin.hpi";
      sha256 = "1zn2bwajziimicjyxj8fi03wq1mnigl7xbj8mmxk52f403z3zb9a";
    };
  };
  "build-publisher-1.21" = mkJenkinsPlugin {
    name = "build-publisher-1.21";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/build-publisher/1.21/build-publisher.hpi";
      sha256 = "1jvldcic5dkk62s1yad1bcslwlddidgzdqk61jf9rbf2nxrgw4ma";
    };
  };
  "build-timeout-1.16" = mkJenkinsPlugin {
    name = "build-timeout-1.16";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/build-timeout/1.16/build-timeout.hpi";
      sha256 = "0lpclxm5wmwm237d86y5zc2rqbm6fa4p54phkq1vkvyw61cc6cyi";
    };
  };
  "build-timestamp-1.0.1" = mkJenkinsPlugin {
    name = "build-timestamp-1.0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/build-timestamp/1.0.1/build-timestamp.hpi";
      sha256 = "1i2h2piil4zs066r92lmwfhqpva78mv70z17k2kz7jv5ksxjdd8s";
    };
  };
  "build-token-root-1.3" = mkJenkinsPlugin {
    name = "build-token-root-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/build-token-root/1.3/build-token-root.hpi";
      sha256 = "1cnqw66znjynzib36pm7r4472r9li9nqsj9s7gj6gnj7gb81i87m";
    };
  };
  "build-user-vars-plugin-1.5" = mkJenkinsPlugin {
    name = "build-user-vars-plugin-1.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/build-user-vars-plugin/1.5/build-user-vars-plugin.hpi";
      sha256 = "0cj9141d3pw0c2081gm8fby3jxgn79wpkmixjf0gm9b72wf85jyl";
    };
  };
  "build-view-column-0.2" = mkJenkinsPlugin {
    name = "build-view-column-0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/build-view-column/0.2/build-view-column.hpi";
      sha256 = "0s2kvwjb2aggb5lijspdq3vry0ca4si0l3mzxq33qvbkp3f0askd";
    };
  };
  "build-with-parameters-1.3" = mkJenkinsPlugin {
    name = "build-with-parameters-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/build-with-parameters/1.3/build-with-parameters.hpi";
      sha256 = "1hgwi39p682vqa435fgrm55p0ldiz26gm8gar9gfj8143xna3pwv";
    };
  };
  "buildcontext-capture-0.6" = mkJenkinsPlugin {
    name = "buildcontext-capture-0.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/buildcontext-capture/0.6/buildcontext-capture.hpi";
      sha256 = "0gajclf9pyknl69ap7fnm1acxi81ax5ijnq9p6zk0yp92zrjxzrz";
    };
  };
  "buildgraph-view-1.1.1" = mkJenkinsPlugin {
    name = "buildgraph-view-1.1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/buildgraph-view/1.1.1/buildgraph-view.hpi";
      sha256 = "07jjk63b1gqqm0jpx93q3carfr0gwgns9wz5xbr6p68cnkmzka11";
    };
  };
  "buildresult-trigger-0.17" = mkJenkinsPlugin {
    name = "buildresult-trigger-0.17";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/buildresult-trigger/0.17/buildresult-trigger.hpi";
      sha256 = "0dy4x6pycb9h2bsqvmvg5qwg7jd8axlbn0qssqpmdd60za9ks8my";
    };
  };
  "buildtriggerbadge-2.2" = mkJenkinsPlugin {
    name = "buildtriggerbadge-2.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/buildtriggerbadge/2.2/buildtriggerbadge.hpi";
      sha256 = "0cz27iwjbbnjjqj60ka664ln2dqizzj4gl32rw0j4w49cl3b3w1v";
    };
  };
  "built-on-column-1.1" = mkJenkinsPlugin {
    name = "built-on-column-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/built-on-column/1.1/built-on-column.hpi";
      sha256 = "13yjjyx7c35k1dsgn5jjpx8dqr2fa0hmhmdnpl1hwy2z8rfpnidv";
    };
  };
  "bulk-builder-1.5" = mkJenkinsPlugin {
    name = "bulk-builder-1.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/bulk-builder/1.5/bulk-builder.hpi";
      sha256 = "1dllwrk7hyiwarfrgqgm52hzpl3fcqwyx23a4an730v78r6dw7lb";
    };
  };
  "bumblebee-4.0.0" = mkJenkinsPlugin {
    name = "bumblebee-4.0.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/bumblebee/4.0.0/bumblebee.hpi";
      sha256 = "0p8i9iq00390hmf7xwgqk4ki431cx25l293zj40j1gg00mdsgni9";
    };
  };
  "call-remote-job-plugin-1.0.21" = mkJenkinsPlugin {
    name = "call-remote-job-plugin-1.0.21";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/call-remote-job-plugin/1.0.21/call-remote-job-plugin.hpi";
      sha256 = "0sbh06931rihw3ci59qlk54c4cqil4nlm7d71542hxsrqi6az2q5";
    };
  };
  "campfire-2.7" = mkJenkinsPlugin {
    name = "campfire-2.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/campfire/2.7/campfire.hpi";
      sha256 = "1nxzh1kza3x9b5rvkqmngpfbnyp27kdwk0qk6pj4n9vlr5xfbdpl";
    };
  };
  "capitomcat-0.1.0" = mkJenkinsPlugin {
    name = "capitomcat-0.1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/capitomcat/0.1.0/capitomcat.hpi";
      sha256 = "0rjh6sv80p37kks92kri3047ajn7lwzprlbds0mq6r2lnyd3xlld";
    };
  };
  "cas-plugin-1.2.0" = mkJenkinsPlugin {
    name = "cas-plugin-1.2.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cas-plugin/1.2.0/cas-plugin.hpi";
      sha256 = "0wwq5qww7si9iwz88nd5fk00x2mim2rbhpkhz97cvbxihdpm3nxg";
    };
  };
  "cas1-1.0.1" = mkJenkinsPlugin {
    name = "cas1-1.0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cas1/1.0.1/cas1.hpi";
      sha256 = "11gv6b1dpnc4ysa309fp7fidfx7msfzqw3j4q2yzrwil86kxsb0y";
    };
  };
  "categorized-view-1.8" = mkJenkinsPlugin {
    name = "categorized-view-1.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/categorized-view/1.8/categorized-view.hpi";
      sha256 = "0viaslsvb643jdc5zmya5bvgsyfrx4w2gfnd9jkrb50ch2m44aqs";
    };
  };
  "cccc-0.6" = mkJenkinsPlugin {
    name = "cccc-0.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cccc/0.6/cccc.hpi";
      sha256 = "16z2ihhg21j2qgcxw37rk1hcjg46z6kgpyiim9fspc7fwgrxyf6b";
    };
  };
  "ccm-3.1" = mkJenkinsPlugin {
    name = "ccm-3.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ccm/3.1/ccm.hpi";
      sha256 = "1kvfmkbnicivy6lj975s0w7p9pbhzv47ppyxwgbg8fgvl2gvlzwl";
    };
  };
  "change-assembly-version-plugin-1.5.1" = mkJenkinsPlugin {
    name = "change-assembly-version-plugin-1.5.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/change-assembly-version-plugin/1.5.1/change-assembly-version-plugin.hpi";
      sha256 = "13zmdzr588l1z3yylcnlw794him45n70z20gp8zdlkcr8v7cwmn5";
    };
  };
  "changelog-history-1.3" = mkJenkinsPlugin {
    name = "changelog-history-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/changelog-history/1.3/changelog-history.hpi";
      sha256 = "07fwpmv816kivd713bzj3as5pm80xb5xkis22fjwbbxa3dyhqqsy";
    };
  };
  "changes-since-last-success-0.5" = mkJenkinsPlugin {
    name = "changes-since-last-success-0.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/changes-since-last-success/0.5/changes-since-last-success.hpi";
      sha256 = "0hknx5arpz46ky5fyi61778q73n2wk60vig1b7nd7p2va3yhy8rb";
    };
  };
  "chatter-notifier-2.0.2" = mkJenkinsPlugin {
    name = "chatter-notifier-2.0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/chatter-notifier/2.0.2/chatter-notifier.hpi";
      sha256 = "18v8a21cmm51xxq4r7i6hxrgpr804ral3g5qfp6y2f6kvvgc1kcn";
    };
  };
  "chatwork-1.0.4" = mkJenkinsPlugin {
    name = "chatwork-1.0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/chatwork/1.0.4/chatwork.hpi";
      sha256 = "0gvrsdv3q504g6imf1pynd32pdzd21f03cl1s06b4r4pz6wgzxpc";
    };
  };
  "checkmarx-7.5.0" = mkJenkinsPlugin {
    name = "checkmarx-7.5.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/checkmarx/7.5.0/checkmarx.hpi";
      sha256 = "1lm5db3ssv5dlgrrvxp6pfkhzn06fmvg2mqmdnwlc9p880bcpd12";
    };
  };
  "checkstyle-3.44" = mkJenkinsPlugin {
    name = "checkstyle-3.44";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/checkstyle/3.44/checkstyle.hpi";
      sha256 = "11rc7nld4hbwpfj73nl708x8vzr0ykl0r4j1f1yxlffi541zca5s";
    };
  };
  "chef-identity-1.0.0" = mkJenkinsPlugin {
    name = "chef-identity-1.0.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/chef-identity/1.0.0/chef-identity.hpi";
      sha256 = "0lf7hsxjics1ihz2f6wyhflp7an49lcfjlig9n1z9m9df4amwsj9";
    };
  };
  "chef-tracking-1.0" = mkJenkinsPlugin {
    name = "chef-tracking-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/chef-tracking/1.0/chef-tracking.hpi";
      sha256 = "0qb7zfzz3wr69icd08h50zww0xsv8jd8hi92cdgdvrjyp3vcm5vv";
    };
  };
  "chosen-views-tabbar-1.2" = mkJenkinsPlugin {
    name = "chosen-views-tabbar-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/chosen-views-tabbar/1.2/chosen-views-tabbar.hpi";
      sha256 = "14wnwslfir4mhb0zrd22ag3dgn2m3llpawh99zph3y2lr8rj2lvs";
    };
  };
  "chosen-1.0" = mkJenkinsPlugin {
    name = "chosen-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/chosen/1.0/chosen.hpi";
      sha256 = "14sv27d0l0snmjiayh622bj2b5g6im2j5nkj7mpbbvfzprqc8516";
    };
  };
  "chrome-frame-plugin-1.1" = mkJenkinsPlugin {
    name = "chrome-frame-plugin-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/chrome-frame-plugin/1.1/chrome-frame-plugin.hpi";
      sha256 = "097zrs0a3rw13hlwi0l52w5sj7qmnvkzmr3nq8alwd360130hxk2";
    };
  };
  "chromedriver-1.2" = mkJenkinsPlugin {
    name = "chromedriver-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/chromedriver/1.2/chromedriver.hpi";
      sha256 = "0j8a3rcgsn6i8anrclch1qp10kif5hvw6x9af2naac8gi417kmj4";
    };
  };
  "chroot-0.1.4" = mkJenkinsPlugin {
    name = "chroot-0.1.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/chroot/0.1.4/chroot.hpi";
      sha256 = "1msm842mkkqcc0iy3f07d29n30lcapxzl0y4i1fpmxzlvn9zfzx4";
    };
  };
  "chucknorris-1.0" = mkJenkinsPlugin {
    name = "chucknorris-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/chucknorris/1.0/chucknorris.hpi";
      sha256 = "06f0716a9879x6rjyb3vcna2a7g7jkxgb5qyy0svsl8g3b9r10i6";
    };
  };
  "ci-game-1.23" = mkJenkinsPlugin {
    name = "ci-game-1.23";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ci-game/1.23/ci-game.hpi";
      sha256 = "0877jfsllrh1kg9kc0k58x19q84x5dms72kak48gih4a5cix1fi2";
    };
  };
  "ci-skip-0.0.2" = mkJenkinsPlugin {
    name = "ci-skip-0.0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ci-skip/0.0.2/ci-skip.hpi";
      sha256 = "0ka58y3v2sgl4r8zmxjxa1is872qi5ax779lwf8m6vms1qs4ia14";
    };
  };
  "claim-2.8" = mkJenkinsPlugin {
    name = "claim-2.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/claim/2.8/claim.hpi";
      sha256 = "0wwpv28k95jspnz3a34k8ad7hiqkx1w6r9fgwxkb64qlbnc2q9pf";
    };
  };
  "clamav-0.3" = mkJenkinsPlugin {
    name = "clamav-0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/clamav/0.3/clamav.hpi";
      sha256 = "0b2xbv07kd4j8ix71kiwsh1ak3jrajrd885nlz8rxaww9d2plq9x";
    };
  };
  "clang-scanbuild-plugin-1.7" = mkJenkinsPlugin {
    name = "clang-scanbuild-plugin-1.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/clang-scanbuild-plugin/1.7/clang-scanbuild-plugin.hpi";
      sha256 = "100ws93divdwa9c29dv1h15gxnxzrbagghm3xg1x3ynns16zhxlj";
    };
  };
  "clearcase-release-0.3" = mkJenkinsPlugin {
    name = "clearcase-release-0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/clearcase-release/0.3/clearcase-release.hpi";
      sha256 = "1255xvrwvzsmmzzz2hn6gpqrsl7wnhmrpc4fpsgdqb7f3yld4xg9";
    };
  };
  "clearcase-ucm-baseline-1.7.4" = mkJenkinsPlugin {
    name = "clearcase-ucm-baseline-1.7.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/clearcase-ucm-baseline/1.7.4/clearcase-ucm-baseline.hpi";
      sha256 = "1q7z25wlzrj8mbc9fhqv8iw905safh3fwwikv6sfpa610j1f3xyh";
    };
  };
  "clearcase-ucm-plugin-1.6.8" = mkJenkinsPlugin {
    name = "clearcase-ucm-plugin-1.6.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/clearcase-ucm-plugin/1.6.8/clearcase-ucm-plugin.hpi";
      sha256 = "0gcfhpd8iv5rcknyz9rxkvvb3vgavp77qnxp87d74i6lgnw8dms1";
    };
  };
  "clearcase-1.6.2" = mkJenkinsPlugin {
    name = "clearcase-1.6.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/clearcase/1.6.2/clearcase.hpi";
      sha256 = "0l9n3j2xrip0gzp0n0wvy4hp2alh3x0c3nxxbxh4ida40ikc6vd5";
    };
  };
  "cli-commander-0.3" = mkJenkinsPlugin {
    name = "cli-commander-0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cli-commander/0.3/cli-commander.hpi";
      sha256 = "1x7xl4pn4zarnhj6z842vrd7799fb0c8hcq9i864af4g725pcw3n";
    };
  };
  "clone-workspace-scm-0.6" = mkJenkinsPlugin {
    name = "clone-workspace-scm-0.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/clone-workspace-scm/0.6/clone-workspace-scm.hpi";
      sha256 = "0ki9ykjfn5av9cn0785xbc22inhzlxhv3db78q6s9kzbqva8h6h3";
    };
  };
  "cloudbees-credentials-3.3" = mkJenkinsPlugin {
    name = "cloudbees-credentials-3.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cloudbees-credentials/3.3/cloudbees-credentials.hpi";
      sha256 = "1m7xilkqkh9q6jd99sgpa66yd50ghyncrhqhpmvn81ffakmkgfpd";
    };
  };
  "cloudbees-disk-usage-simple-0.5" = mkJenkinsPlugin {
    name = "cloudbees-disk-usage-simple-0.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cloudbees-disk-usage-simple/0.5/cloudbees-disk-usage-simple.hpi";
      sha256 = "10s2ljkb8j16hlyam0vmzky9kdklrgylddzpx4x5vlsfdlf49waa";
    };
  };
  "cloudbees-enterprise-plugins-15.05.1" = mkJenkinsPlugin {
    name = "cloudbees-enterprise-plugins-15.05.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cloudbees-enterprise-plugins/15.05.1/cloudbees-enterprise-plugins.hpi";
      sha256 = "0ikx9wx7c0gk7m107mhdfxh5za6vn153q2in77zrrrjif8j7x6nb";
    };
  };
  "cloudbees-folder-5.1" = mkJenkinsPlugin {
    name = "cloudbees-folder-5.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cloudbees-folder/5.1/cloudbees-folder.hpi";
      sha256 = "1r2naik010wqjg4r5c2lw8pqx1x3gbj913v3rm90670vrlahf7rp";
    };
  };
  "cloudbees-plugin-gateway-7.0" = mkJenkinsPlugin {
    name = "cloudbees-plugin-gateway-7.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cloudbees-plugin-gateway/7.0/cloudbees-plugin-gateway.hpi";
      sha256 = "1cbzyfb4qmachgpbc1i6gnjxd0q9wxm348b5qs57cwbway5ncx5l";
    };
  };
  "cloudbees-registration-3.14" = mkJenkinsPlugin {
    name = "cloudbees-registration-3.14";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cloudbees-registration/3.14/cloudbees-registration.hpi";
      sha256 = "11in8lgwn7pk6kxfghbc0pfvbbyq86gjmn4b6xmlrh1kfvbgjzc9";
    };
  };
  "cloudfoundry-1.5" = mkJenkinsPlugin {
    name = "cloudfoundry-1.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cloudfoundry/1.5/cloudfoundry.hpi";
      sha256 = "0fybmgfgynf07c9w55y4h50z03s27lqqn4j4avxsvn9qyjfybha0";
    };
  };
  "cloudtest-2.20" = mkJenkinsPlugin {
    name = "cloudtest-2.20";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cloudtest/2.20/cloudtest.hpi";
      sha256 = "1cx71yzpc5z3rbvqyzppiz47i5i2v22mlpai1n5mzv1lkj26xxm7";
    };
  };
  "clover-4.5.0" = mkJenkinsPlugin {
    name = "clover-4.5.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/clover/4.5.0/clover.hpi";
      sha256 = "099fbs7zzrg1v2rvhy4hkcm92d7frjffv35ja2ripnscxfjaz02j";
    };
  };
  "cloverphp-0.5" = mkJenkinsPlugin {
    name = "cloverphp-0.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cloverphp/0.5/cloverphp.hpi";
      sha256 = "1iw93gw2my79mykagyxajcsc37kvgb2m05h7v09pi3hzjwa8p24h";
    };
  };
  "cluster-stats-0.4.6" = mkJenkinsPlugin {
    name = "cluster-stats-0.4.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cluster-stats/0.4.6/cluster-stats.hpi";
      sha256 = "1lmxf6ksfg1mqkf4l1n95nlg3i9n66qsjz54kj9l6pc43p3jbxyq";
    };
  };
  "cmakebuilder-2.3.3" = mkJenkinsPlugin {
    name = "cmakebuilder-2.3.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cmakebuilder/2.3.3/cmakebuilder.hpi";
      sha256 = "1s1l0ysiqdw6la8gq2dq0m3fgaciy3n0fas8yr8qypf6sa3s7zwj";
    };
  };
  "cmvc-0.4" = mkJenkinsPlugin {
    name = "cmvc-0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cmvc/0.4/cmvc.hpi";
      sha256 = "0jmv9lp6zf1ip47zqhvxiychjss1rakbfi8zb05k2wiinm0dwfc3";
    };
  };
  "cobertura-1.9.7" = mkJenkinsPlugin {
    name = "cobertura-1.9.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cobertura/1.9.7/cobertura.hpi";
      sha256 = "1g7rck2bx3gndvhdz5naf8zm6rhr89pg6vbralmsd00h7qamhyss";
    };
  };
  "cocoapods-integration-0.2.0" = mkJenkinsPlugin {
    name = "cocoapods-integration-0.2.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cocoapods-integration/0.2.0/cocoapods-integration.hpi";
      sha256 = "1j4y1dfpr953nwj06ybmpnzdxacazml4i9w47wz543pcipr4bdc6";
    };
  };
  "codebeamer-result-trend-updater-1.0.2" = mkJenkinsPlugin {
    name = "codebeamer-result-trend-updater-1.0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/codebeamer-result-trend-updater/1.0.2/codebeamer-result-trend-updater.hpi";
      sha256 = "13ns9a0sxbygwll29sbgl5s4ca2vgy0xyj6ak471yj6v0p30hdh8";
    };
  };
  "codecover-1.1" = mkJenkinsPlugin {
    name = "codecover-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/codecover/1.1/codecover.hpi";
      sha256 = "1ii642l4zasp7cx8z2k8lfb2pp3d83xrr40rqx89gy7z8c3m1g56";
    };
  };
  "codedeploy-1.9" = mkJenkinsPlugin {
    name = "codedeploy-1.9";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/codedeploy/1.9/codedeploy.hpi";
      sha256 = "15dqvy6449s5gfn5zx3yjl0zwr13cllgdr090acndd418yj2vw23";
    };
  };
  "codedx-2.0" = mkJenkinsPlugin {
    name = "codedx-2.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/codedx/2.0/codedx.hpi";
      sha256 = "0hic0rvnsffiqnhw0h9f1hbmqpabxpbrmpshh1lrx5163sk0j09i";
    };
  };
  "codescanner-0.11" = mkJenkinsPlugin {
    name = "codescanner-0.11";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/codescanner/0.11/codescanner.hpi";
      sha256 = "063ijpf6j4zcda7d5nmj3iymcv8psk4kcbwlks9gm6hsh8z8wskn";
    };
  };
  "codesonar-1.0.1" = mkJenkinsPlugin {
    name = "codesonar-1.0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/codesonar/1.0.1/codesonar.hpi";
      sha256 = "0h51g35slg6pb4760h8lrpp5fzpj1058bjgbn2mxyz4ihbjx709h";
    };
  };
  "collabnet-1.1.10" = mkJenkinsPlugin {
    name = "collabnet-1.1.10";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/collabnet/1.1.10/collabnet.hpi";
      sha256 = "14hg1icqmsn4fc7yim5axcr62pr2avbzs9d94qw4nbganqy1jvg1";
    };
  };
  "collapsing-console-sections-1.4.1" = mkJenkinsPlugin {
    name = "collapsing-console-sections-1.4.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/collapsing-console-sections/1.4.1/collapsing-console-sections.hpi";
      sha256 = "0jb0qjzvrmiqw8fqrj0pb04l6zwc928cjl7m9cpz470hv6flgwrq";
    };
  };
  "commit-message-trigger-plugin-0.1" = mkJenkinsPlugin {
    name = "commit-message-trigger-plugin-0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/commit-message-trigger-plugin/0.1/commit-message-trigger-plugin.hpi";
      sha256 = "164dhhxxy9wyc0g3h5q5hnrbsf41asaplv85pxnxsjp3a6p6066m";
    };
  };
  "compact-columns-1.10" = mkJenkinsPlugin {
    name = "compact-columns-1.10";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/compact-columns/1.10/compact-columns.hpi";
      sha256 = "1bsx1a5ilqb6bn4hzhjv3c37pn2xzvfdg99iyviwf7n2x6shxzj7";
    };
  };
  "compatibility-action-storage-1.0" = mkJenkinsPlugin {
    name = "compatibility-action-storage-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/compatibility-action-storage/1.0/compatibility-action-storage.hpi";
      sha256 = "12a64i94vl9y6ik53isfzmgfr896fq5arf50x4kdv9213yqih3v1";
    };
  };
  "composer-security-checker-1.7" = mkJenkinsPlugin {
    name = "composer-security-checker-1.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/composer-security-checker/1.7/composer-security-checker.hpi";
      sha256 = "0h1vbj26sqsl7dwm59gdr8dmfvs05cdgvv77xcl7b561mbqs5ic0";
    };
  };
  "compound-slaves-1.2" = mkJenkinsPlugin {
    name = "compound-slaves-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/compound-slaves/1.2/compound-slaves.hpi";
      sha256 = "18dsxr9kd3a0c81zzdrd8sj7nw7z84n18y50dpf7n8qc8szq8msh";
    };
  };
  "compress-artifacts-1.7" = mkJenkinsPlugin {
    name = "compress-artifacts-1.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/compress-artifacts/1.7/compress-artifacts.hpi";
      sha256 = "07rb955qzmwhjh3l24bzc6w49xz7jra73pz8p7gm74d7rm0d8lbv";
    };
  };
  "compress-buildlog-1.0" = mkJenkinsPlugin {
    name = "compress-buildlog-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/compress-buildlog/1.0/compress-buildlog.hpi";
      sha256 = "08rs9vfiyn5a425b3k83qwm476hh9iyl8djs1x2acnfbqxz644xy";
    };
  };
  "computer-queue-plugin-1.4" = mkJenkinsPlugin {
    name = "computer-queue-plugin-1.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/computer-queue-plugin/1.4/computer-queue-plugin.hpi";
      sha256 = "19cnv2r7akcgwzxaps7s27x5j8lpz8h45hsv0yh3v3q26ka912bl";
    };
  };
  "compuware-scm-downloader-1.4" = mkJenkinsPlugin {
    name = "compuware-scm-downloader-1.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/compuware-scm-downloader/1.4/compuware-scm-downloader.hpi";
      sha256 = "0blyl4sw01sb60j8hnik8va93wg3shr5xb049hjc9ls8zcsa1n7q";
    };
  };
  "concordionpresenter-0.7" = mkJenkinsPlugin {
    name = "concordionpresenter-0.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/concordionpresenter/0.7/concordionpresenter.hpi";
      sha256 = "0mvm5fs5sixkjgrxffi8jigwp73n424k52dzq7rn4k632nlicx65";
    };
  };
  "concurrent-login-plugin-0.7" = mkJenkinsPlugin {
    name = "concurrent-login-plugin-0.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/concurrent-login-plugin/0.7/concurrent-login-plugin.hpi";
      sha256 = "0i3ij1ni1y0p7b2147jv8i2cvcm0vr5fsi9i7c5bvd4bpijd4rbs";
    };
  };
  "conditional-buildstep-1.3.3" = mkJenkinsPlugin {
    name = "conditional-buildstep-1.3.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/conditional-buildstep/1.3.3/conditional-buildstep.hpi";
      sha256 = "0p1vjy29bgcxv9lipb1cz8gjr0db310ds156kxvndijf2sd9kh0v";
    };
  };
  "config-autorefresh-plugin-1.0" = mkJenkinsPlugin {
    name = "config-autorefresh-plugin-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/config-autorefresh-plugin/1.0/config-autorefresh-plugin.hpi";
      sha256 = "1pl16z9cwk4h9anynfpkz226cg5fy7ldzwny91mwc1iqag1zd4a6";
    };
  };
  "config-file-provider-2.10.0" = mkJenkinsPlugin {
    name = "config-file-provider-2.10.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/config-file-provider/2.10.0/config-file-provider.hpi";
      sha256 = "16jkzpxfirwl3wkimz90rzwhkqmgarwmfk2ksmnpfivbdy6wb57n";
    };
  };
  "config-rotator-1.3.1" = mkJenkinsPlugin {
    name = "config-rotator-1.3.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/config-rotator/1.3.1/config-rotator.hpi";
      sha256 = "1cjdpn9wgl3hiqnmq090dv7v216s83apw1j5iynsb3d45xvmp76s";
    };
  };
  "configurationslicing-1.44" = mkJenkinsPlugin {
    name = "configurationslicing-1.44";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/configurationslicing/1.44/configurationslicing.hpi";
      sha256 = "08mkd67ph91assw5i7djzhby7qn311gydx0xq6khqdn0fbpbz3qj";
    };
  };
  "configure-job-column-plugin-1.0" = mkJenkinsPlugin {
    name = "configure-job-column-plugin-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/configure-job-column-plugin/1.0/configure-job-column-plugin.hpi";
      sha256 = "0mmyznanx7yyp8m3iv7jqgpq5ha0fbf30pvdmplq0s70gd4r2l2c";
    };
  };
  "confluence-publisher-1.8" = mkJenkinsPlugin {
    name = "confluence-publisher-1.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/confluence-publisher/1.8/confluence-publisher.hpi";
      sha256 = "1fbfd8vnsvw42mj2qp673firrzhgii3y4ffli0wqq41i7cmn5y95";
    };
  };
  "console-column-plugin-1.5" = mkJenkinsPlugin {
    name = "console-column-plugin-1.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/console-column-plugin/1.5/console-column-plugin.hpi";
      sha256 = "1p44y7xy4khqh7l3pdf6gkpai4d9csmgl19n5kdbgrs224rlqd7z";
    };
  };
  "console-tail-1.1" = mkJenkinsPlugin {
    name = "console-tail-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/console-tail/1.1/console-tail.hpi";
      sha256 = "0jsmf0flh2q0dymqfyaw0ff28j11vjybhja0nxy3yvna6fz51v68";
    };
  };
  "convertigo-mobile-platform-1.1" = mkJenkinsPlugin {
    name = "convertigo-mobile-platform-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/convertigo-mobile-platform/1.1/convertigo-mobile-platform.hpi";
      sha256 = "1wd6zhffn89ckyx7idhf6mabjq7c44zh8ngg6mh0vgfspfbbbb26";
    };
  };
  "coordinator-1.1.1" = mkJenkinsPlugin {
    name = "coordinator-1.1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/coordinator/1.1.1/coordinator.hpi";
      sha256 = "0bq2mwgn8j1y5axisi49qxvnlqnicc7gdxgwhd0wvw6dzzyhmkfc";
    };
  };
  "copado-1.00" = mkJenkinsPlugin {
    name = "copado-1.00";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/copado/1.00/copado.hpi";
      sha256 = "1pjxajr5l183aw7x9wgz702hk5dvv0biss04knhy2sdyssmxfb76";
    };
  };
  "copr-0.3" = mkJenkinsPlugin {
    name = "copr-0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/copr/0.3/copr.hpi";
      sha256 = "135ykjw6b6260ld1sr6y0igg1qbcyyqplvwjrixw4pyzy01sfn6y";
    };
  };
  "copy-data-to-workspace-plugin-1.0" = mkJenkinsPlugin {
    name = "copy-data-to-workspace-plugin-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/copy-data-to-workspace-plugin/1.0/copy-data-to-workspace-plugin.hpi";
      sha256 = "0ncmq0l3fvljplpj5s5mwa3609iqjy874hy6j2k83kjlk5fw0264";
    };
  };
  "copy-project-link-1.5" = mkJenkinsPlugin {
    name = "copy-project-link-1.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/copy-project-link/1.5/copy-project-link.hpi";
      sha256 = "0xlgzbbwyz1yylb5hhb95yx0da28jwiwsbzvxlvngmjyw68i4b3v";
    };
  };
  "copy-to-slave-1.4.4" = mkJenkinsPlugin {
    name = "copy-to-slave-1.4.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/copy-to-slave/1.4.4/copy-to-slave.hpi";
      sha256 = "1x609sqv40sijs5701d64z55hp9hrc5yvx2xzfd07qqx2x5vm8cn";
    };
  };
  "copyartifact-1.37" = mkJenkinsPlugin {
    name = "copyartifact-1.37";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/copyartifact/1.37/copyartifact.hpi";
      sha256 = "1mbx9nwsnx0vmvx4dwc9w5hxm4zffqwgmk6xpi670izc0i5mbl6l";
    };
  };
  "cors-filter-1.1" = mkJenkinsPlugin {
    name = "cors-filter-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cors-filter/1.1/cors-filter.hpi";
      sha256 = "1iwsys223gvj53bxc9kq8b8mz4sw64z8jskd8l3lrw68brrf5n4w";
    };
  };
  "couchdb-statistics-0.3" = mkJenkinsPlugin {
    name = "couchdb-statistics-0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/couchdb-statistics/0.3/couchdb-statistics.hpi";
      sha256 = "1mz6xvpqmcghjp8f6krgk5zfdpg1q8wzr0bc0b1snaypsyajblxp";
    };
  };
  "countjobs-viewstabbar-1.0.0" = mkJenkinsPlugin {
    name = "countjobs-viewstabbar-1.0.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/countjobs-viewstabbar/1.0.0/countjobs-viewstabbar.hpi";
      sha256 = "02lgvb55xnwkf3zzjr0nvx0pbbwxhjp4gbdfy0pdw2p8haqba03k";
    };
  };
  "covcomplplot-1.1.1" = mkJenkinsPlugin {
    name = "covcomplplot-1.1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/covcomplplot/1.1.1/covcomplplot.hpi";
      sha256 = "00w6dnvjzzfdd76dbd0sw3v218v2vrgl8briz96sg2408ih5xmdz";
    };
  };
  "coverity-1.6.0" = mkJenkinsPlugin {
    name = "coverity-1.6.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/coverity/1.6.0/coverity.hpi";
      sha256 = "08yh42khmn6n9g9432iwfg4d7qfsarlp0ycm0y02jdqmlnwipp16";
    };
  };
  "cppcheck-1.21" = mkJenkinsPlugin {
    name = "cppcheck-1.21";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cppcheck/1.21/cppcheck.hpi";
      sha256 = "1wa67z2dghz2vvsyqjrvr1cgzcw7zpw1x64x2i3zjy9mywg4msb2";
    };
  };
  "cppncss-1.1" = mkJenkinsPlugin {
    name = "cppncss-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cppncss/1.1/cppncss.hpi";
      sha256 = "0xafkfi995r7mhqis9xrpdi7qysdf81xc68n89j1lc6qjyvya8cd";
    };
  };
  "cpptest-0.14" = mkJenkinsPlugin {
    name = "cpptest-0.14";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cpptest/0.14/cpptest.hpi";
      sha256 = "0kjwkv1gh38l3irp4dli323lapm03hf2s7r5sc2c10mlm389d5xi";
    };
  };
  "crap4j-0.9" = mkJenkinsPlugin {
    name = "crap4j-0.9";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/crap4j/0.9/crap4j.hpi";
      sha256 = "1wzzmbsj215cj3xyr4j0s8cj0bsh2ckmlxsp4gs7r2c23v0fsxqx";
    };
  };
  "create-fingerprint-1.2" = mkJenkinsPlugin {
    name = "create-fingerprint-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/create-fingerprint/1.2/create-fingerprint.hpi";
      sha256 = "099i48v3qday613ycrqwd7n8fa79zc1sy4fqlr72nw95jzglb3p1";
    };
  };
  "createjobadvanced-1.8" = mkJenkinsPlugin {
    name = "createjobadvanced-1.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/createjobadvanced/1.8/createjobadvanced.hpi";
      sha256 = "0jv24jx1xic34kvkxqvaqxkwl7wrb4jhi7qkkrik36cyzzj1hzc1";
    };
  };
  "credentials-binding-1.6" = mkJenkinsPlugin {
    name = "credentials-binding-1.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/credentials-binding/1.6/credentials-binding.hpi";
      sha256 = "0in6wc0f9s68l181w7nnxyf9jlv91psl4rjbl99cpklnsxzhb6bz";
    };
  };
  "credentials-1.24" = mkJenkinsPlugin {
    name = "credentials-1.24";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/credentials/1.24/credentials.hpi";
      sha256 = "14bzsp8mq7cfv37gxj9g7y72xcjnvjigf6s54bf2g7bz2082fv57";
    };
  };
  "crittercism-dsym-1.1" = mkJenkinsPlugin {
    name = "crittercism-dsym-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/crittercism-dsym/1.1/crittercism-dsym.hpi";
      sha256 = "00bhih450dgqnawzy6pmbribzdv6s7qqmw7zmsh8apzkgqgvda7a";
    };
  };
  "cron_column-1.4" = mkJenkinsPlugin {
    name = "cron_column-1.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cron_column/1.4/cron_column.hpi";
      sha256 = "10c2wys3dzdkbx8cci1208a3q36r15l6245grlsmy93s9faq7sf8";
    };
  };
  "crossbrowsertesting-0.5" = mkJenkinsPlugin {
    name = "crossbrowsertesting-0.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/crossbrowsertesting/0.5/crossbrowsertesting.hpi";
      sha256 = "07gffg9yn21vay3drzia1vxh5a2ys35px2z80c8w15f4abymxhzk";
    };
  };
  "crowd-1.2" = mkJenkinsPlugin {
    name = "crowd-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/crowd/1.2/crowd.hpi";
      sha256 = "01rn6gmvqlxv5wr244ldc3nqb3ik7d42lrgamvgkkmgd50pxhfcz";
    };
  };
  "crowd2-1.8" = mkJenkinsPlugin {
    name = "crowd2-1.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/crowd2/1.8/crowd2.hpi";
      sha256 = "17pg9r3khvgnj3amxfwry68c2cls73wv2qjq0aqcjpzf49572w1z";
    };
  };
  "crx-content-package-deployer-1.3.2" = mkJenkinsPlugin {
    name = "crx-content-package-deployer-1.3.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/crx-content-package-deployer/1.3.2/crx-content-package-deployer.hpi";
      sha256 = "1acprsab6zz5hhxsdqg1pck9k2mpwvdzrvhl0vylb0bqjbg86srv";
    };
  };
  "cucumber-perf-2.0.6" = mkJenkinsPlugin {
    name = "cucumber-perf-2.0.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cucumber-perf/2.0.6/cucumber-perf.hpi";
      sha256 = "1xmfzivk7j2rchj7ima5k0h74ghxmcwiwi85blbfpqfxakmmwyjy";
    };
  };
  "cucumber-reports-1.2.0" = mkJenkinsPlugin {
    name = "cucumber-reports-1.2.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cucumber-reports/1.2.0/cucumber-reports.hpi";
      sha256 = "1x8zi94xa62804dh8yd19j7kb221db99rhwxixl9nznzbgy83dcw";
    };
  };
  "cucumber-slack-notifier-0.7.1" = mkJenkinsPlugin {
    name = "cucumber-slack-notifier-0.7.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cucumber-slack-notifier/0.7.1/cucumber-slack-notifier.hpi";
      sha256 = "08pi77ssq266y5nvsy1gzrj75brjwg2cm1lxng84427fkb5242r8";
    };
  };
  "cucumber-testresult-plugin-0.8.2" = mkJenkinsPlugin {
    name = "cucumber-testresult-plugin-0.8.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cucumber-testresult-plugin/0.8.2/cucumber-testresult-plugin.hpi";
      sha256 = "0n776140yc7456qy1qcb61k2d9jcj4w6xm4bpxj4gfm3wjksim7i";
    };
  };
  "curseforge-publisher-1.0" = mkJenkinsPlugin {
    name = "curseforge-publisher-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/curseforge-publisher/1.0/curseforge-publisher.hpi";
      sha256 = "0hd5mbcqinxagja56imndz77a7q06wqw9v2kblgk6ynncij26rfa";
    };
  };
  "custom-job-icon-0.2" = mkJenkinsPlugin {
    name = "custom-job-icon-0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/custom-job-icon/0.2/custom-job-icon.hpi";
      sha256 = "0fjdamxcnrl8ncy2xnvmnyl789g8vap044n6fkmp7dvrwxyra6lc";
    };
  };
  "custom-tools-plugin-0.4.4" = mkJenkinsPlugin {
    name = "custom-tools-plugin-0.4.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/custom-tools-plugin/0.4.4/custom-tools-plugin.hpi";
      sha256 = "0wkfawwnv25yl2g62nag3pwi2k58dfvlc7qdkd4y896s26hpsqn1";
    };
  };
  "custom-view-tabs-1.0" = mkJenkinsPlugin {
    name = "custom-view-tabs-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/custom-view-tabs/1.0/custom-view-tabs.hpi";
      sha256 = "1agpjvwrxzw3dx2yi3cgsc0rmjv3pz807g4h95zxc3kxrqkjafz7";
    };
  };
  "customize-build-now-1.1" = mkJenkinsPlugin {
    name = "customize-build-now-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/customize-build-now/1.1/customize-build-now.hpi";
      sha256 = "1qd1id18jqx551ipa2959da01cph2ki7zhanz2bsxg5wm5b5y3gp";
    };
  };
  "cvs-tag-1.7" = mkJenkinsPlugin {
    name = "cvs-tag-1.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cvs-tag/1.7/cvs-tag.hpi";
      sha256 = "1f5samgbzqxzy1h5cbcn9p5fj1mg1p0h8509h64cw5rlw8xmprs9";
    };
  };
  "cvs-2.12" = mkJenkinsPlugin {
    name = "cvs-2.12";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cvs/2.12/cvs.hpi";
      sha256 = "1fkqhhhcbvzjh7y2fqv03bjmq5k1vc8d4hwx9bwga6shx0szsvbf";
    };
  };
  "cygpath-1.5" = mkJenkinsPlugin {
    name = "cygpath-1.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cygpath/1.5/cygpath.hpi";
      sha256 = "0fj7f77g1vjnq2xk4mnxnf62m3ina83k0l8mawfiqld5j53da968";
    };
  };
  "cygwin-process-killer-0.1" = mkJenkinsPlugin {
    name = "cygwin-process-killer-0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/cygwin-process-killer/0.1/cygwin-process-killer.hpi";
      sha256 = "1kn0skwipyd83z01dlvddp3khl8jlkrwr2l8w0yjzyxa5x30f8kf";
    };
  };
  "daily-quote-1.0" = mkJenkinsPlugin {
    name = "daily-quote-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/daily-quote/1.0/daily-quote.hpi";
      sha256 = "1hbji944nllqyr2d3rcahg5dqp65din7jv99mb0jf5kgywbbzrp0";
    };
  };
  "darcs-0.3.11" = mkJenkinsPlugin {
    name = "darcs-0.3.11";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/darcs/0.3.11/darcs.hpi";
      sha256 = "0w2qm421vskwc23x4s7qhfs9mkpqvcs88vxbakjia7ppji4pz947";
    };
  };
  "dashboard-view-2.9.7" = mkJenkinsPlugin {
    name = "dashboard-view-2.9.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/dashboard-view/2.9.7/dashboard-view.hpi";
      sha256 = "0zziq157f8043qsk3vw8aap5hw1mvi543d018daq2my32x4xqqm4";
    };
  };
  "database-h2-1.1" = mkJenkinsPlugin {
    name = "database-h2-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/database-h2/1.1/database-h2.hpi";
      sha256 = "0ppjl47mvg0byqs8cshnpk69c1vjgx9c8x4s03a330crl52n2k55";
    };
  };
  "database-mysql-1.0" = mkJenkinsPlugin {
    name = "database-mysql-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/database-mysql/1.0/database-mysql.hpi";
      sha256 = "09kiybvii77y9v1sjx0g803c5nfp29h9701pnkx7kld2xda6jp3g";
    };
  };
  "database-postgresql-1.0" = mkJenkinsPlugin {
    name = "database-postgresql-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/database-postgresql/1.0/database-postgresql.hpi";
      sha256 = "0gjara70mrkv9wwjwqwiq8szqz9nq4arcg60b9j1n1ccnv3mb44v";
    };
  };
  "database-1.3" = mkJenkinsPlugin {
    name = "database-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/database/1.3/database.hpi";
      sha256 = "0m5nrw3g49fzqkjmybczrdlhqnzw40a1mdmlxllgyqpv3mjips6z";
    };
  };
  "datadog-0.4.1" = mkJenkinsPlugin {
    name = "datadog-0.4.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/datadog/0.4.1/datadog.hpi";
      sha256 = "0j431mxhfvjzgi735x3s5732az50s583q1rkk5k9c70p064dg2sj";
    };
  };
  "datical-db-plugin-1.0.38" = mkJenkinsPlugin {
    name = "datical-db-plugin-1.0.38";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/datical-db-plugin/1.0.38/datical-db-plugin.hpi";
      sha256 = "1p10i0236pk3hqxkh54lq5pbh81yz5ws3w1ipxl0s9m354dfdj9k";
    };
  };
  "dbCharts-0.5.2" = mkJenkinsPlugin {
    name = "dbCharts-0.5.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/dbCharts/0.5.2/dbCharts.hpi";
      sha256 = "10hcgfzcs0an69l58zxpx4r3al0r8wsl27fxzpzafzsdxdpf8q6h";
    };
  };
  "debian-package-builder-1.6.11" = mkJenkinsPlugin {
    name = "debian-package-builder-1.6.11";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/debian-package-builder/1.6.11/debian-package-builder.hpi";
      sha256 = "0xzhjw7il12kghw3hcr2nhkcvyxnxra5a0y490661fn635nf7mm6";
    };
  };
  "delete-log-plugin-1.0" = mkJenkinsPlugin {
    name = "delete-log-plugin-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/delete-log-plugin/1.0/delete-log-plugin.hpi";
      sha256 = "1fvyh1qcrlvzij9p440l4r977nnd2raw2g94vp7g0k8fy0f4k5ik";
    };
  };
  "delivery-pipeline-plugin-0.9.8" = mkJenkinsPlugin {
    name = "delivery-pipeline-plugin-0.9.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/delivery-pipeline-plugin/0.9.8/delivery-pipeline-plugin.hpi";
      sha256 = "02vl5ddiysii1ay8hffgqlm43skih12k1crld5hhnz8mpzgh8vcy";
    };
  };
  "delphix-1.0.7" = mkJenkinsPlugin {
    name = "delphix-1.0.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/delphix/1.0.7/delphix.hpi";
      sha256 = "1y9q297xb0mm2c5kmlqy2rs9j0xjlxavxqk5bnldgdk52kvp4cgp";
    };
  };
  "delta-cloud-1.0.1" = mkJenkinsPlugin {
    name = "delta-cloud-1.0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/delta-cloud/1.0.1/delta-cloud.hpi";
      sha256 = "1zwm57w2x02hdgzzmiy4qpf2qpzm6brgnz5xrnk5cfjhalifc071";
    };
  };
  "dependency-check-jenkins-plugin-1.3.4" = mkJenkinsPlugin {
    name = "dependency-check-jenkins-plugin-1.3.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/dependency-check-jenkins-plugin/1.3.4/dependency-check-jenkins-plugin.hpi";
      sha256 = "1z65yizrk3ax3bpvzl36gcahb45lwxaldihd2zq398h27mp60dxd";
    };
  };
  "dependency-queue-plugin-1.1" = mkJenkinsPlugin {
    name = "dependency-queue-plugin-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/dependency-queue-plugin/1.1/dependency-queue-plugin.hpi";
      sha256 = "1i7j2k9x3fmwaz6sc9n8kwhy17m4iaq13lqdlcfpps4gkk4b8xsg";
    };
  };
  "dependencyanalyzer-0.7" = mkJenkinsPlugin {
    name = "dependencyanalyzer-0.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/dependencyanalyzer/0.7/dependencyanalyzer.hpi";
      sha256 = "1358bdn8kb0fxmddhxpd0f03pgnivshn3b5106wyhwwxj4m91gdi";
    };
  };
  "depgraph-view-0.11" = mkJenkinsPlugin {
    name = "depgraph-view-0.11";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/depgraph-view/0.11/depgraph-view.hpi";
      sha256 = "0s1fgq8mnqf9gw7lrw10aiqlnysj8xyr24clfwc4lc0y43c8b6py";
    };
  };
  "deploy-websphere-1.0" = mkJenkinsPlugin {
    name = "deploy-websphere-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/deploy-websphere/1.0/deploy-websphere.hpi";
      sha256 = "17cg23cnbwjv2b50g2b8brfmqlvyshlh87x13hy0djbr2sq5nv04";
    };
  };
  "deploy-1.10" = mkJenkinsPlugin {
    name = "deploy-1.10";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/deploy/1.10/deploy.hpi";
      sha256 = "07ciyw9mhjgf0fqbg8qjshvzxn5g02gj4mj35vm8dijpyhb9790r";
    };
  };
  "deploydb-0.1" = mkJenkinsPlugin {
    name = "deploydb-0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/deploydb/0.1/deploydb.hpi";
      sha256 = "0228v73wh3mmdd2s6bdd89mawmrl3rj5ljr3hcsf6iy7q2wdq9g2";
    };
  };
  "deployed-on-column-1.7" = mkJenkinsPlugin {
    name = "deployed-on-column-1.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/deployed-on-column/1.7/deployed-on-column.hpi";
      sha256 = "15zzdswwi6xc600zs33yzbl70dk9a1c0f00vxw52zrs5n4y63inx";
    };
  };
  "deployer-framework-1.1" = mkJenkinsPlugin {
    name = "deployer-framework-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/deployer-framework/1.1/deployer-framework.hpi";
      sha256 = "018kvwj7zwbn7a2ljhmhm66xwis4cn8mracs9h16vzhlr5qsnxlx";
    };
  };
  "deployit-plugin-5.0.2" = mkJenkinsPlugin {
    name = "deployit-plugin-5.0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/deployit-plugin/5.0.2/deployit-plugin.hpi";
      sha256 = "0v9j9ads61aq4km1ajhcnb8y167qbqmzq65mi0j7rs54mp8sa67g";
    };
  };
  "deployment-notification-1.3" = mkJenkinsPlugin {
    name = "deployment-notification-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/deployment-notification/1.3/deployment-notification.hpi";
      sha256 = "19q2s8caavihya6w42j01k0089ivdkrr092w0274fzxf9bls77x5";
    };
  };
  "deployment-sphere-0.1.105" = mkJenkinsPlugin {
    name = "deployment-sphere-0.1.105";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/deployment-sphere/0.1.105/deployment-sphere.hpi";
      sha256 = "0km1gip74lwq00i13pq31vkwbbrkpn8252dnhh959mvrhlb7n03n";
    };
  };
  "description-column-plugin-1.3" = mkJenkinsPlugin {
    name = "description-column-plugin-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/description-column-plugin/1.3/description-column-plugin.hpi";
      sha256 = "1n13h9cmqrcnpbmgc3bibp8x15lr74bw82qgf78kxsbv52bkzj1n";
    };
  };
  "description-setter-1.10" = mkJenkinsPlugin {
    name = "description-setter-1.10";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/description-setter/1.10/description-setter.hpi";
      sha256 = "0s01wdx88rw0hw4hgnvz4jzsg193q1k855an0dp22m467vplcx2y";
    };
  };
  "deveo-1.1.2" = mkJenkinsPlugin {
    name = "deveo-1.1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/deveo/1.1.2/deveo.hpi";
      sha256 = "1vy9w614aval0qfd0grk95rklkr9575ay3chmmibzriz7aqivpwv";
    };
  };
  "dimensionsscm-0.8.13" = mkJenkinsPlugin {
    name = "dimensionsscm-0.8.13";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/dimensionsscm/0.8.13/dimensionsscm.hpi";
      sha256 = "18yg2s5lm19x929xnjski194jkm270mgzsay24pkikmmkwl56jj6";
    };
  };
  "disable-failed-job-1.15" = mkJenkinsPlugin {
    name = "disable-failed-job-1.15";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/disable-failed-job/1.15/disable-failed-job.hpi";
      sha256 = "0l0ahqc2g5gv0szjm5q5nrs9jxrvk8k9q3sbyxr7dbh6ly1lv68n";
    };
  };
  "discard-old-build-1.05" = mkJenkinsPlugin {
    name = "discard-old-build-1.05";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/discard-old-build/1.05/discard-old-build.hpi";
      sha256 = "10lfr94pg8yhp637wfw5bsqrv8y4f9ydxm6ri8gbrfdqwqq70rvg";
    };
  };
  "discobit-autoconfig-0.9.1" = mkJenkinsPlugin {
    name = "discobit-autoconfig-0.9.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/discobit-autoconfig/0.9.1/discobit-autoconfig.hpi";
      sha256 = "1wj71fnfxpd52k2d9yhi7m1z1xydfv4lgj942g7k6pfv69ja275m";
    };
  };
  "disk-usage-0.28" = mkJenkinsPlugin {
    name = "disk-usage-0.28";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/disk-usage/0.28/disk-usage.hpi";
      sha256 = "07x9hn1cpcirfczpfmv06n76q6mkcjklwj6gi5rachqws1nr38h5";
    };
  };
  "diskcheck-0.26" = mkJenkinsPlugin {
    name = "diskcheck-0.26";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/diskcheck/0.26/diskcheck.hpi";
      sha256 = "0wijn8b8lgzqkismmvixpzr2frxzs416ij5aw7n8al8kxqqyvsvb";
    };
  };
  "display-upstream-changes-0.1" = mkJenkinsPlugin {
    name = "display-upstream-changes-0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/display-upstream-changes/0.1/display-upstream-changes.hpi";
      sha256 = "0i6qxk8gy2kb17divy1mnhc5d09hwm336kl86yxkxn98cs8m613y";
    };
  };
  "distTest-1.0" = mkJenkinsPlugin {
    name = "distTest-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/distTest/1.0/distTest.hpi";
      sha256 = "0irrb4ykhzjmbd3xfc437qn5qdfxrm1xllxpmvmw44dsvr0w6nz1";
    };
  };
  "distfork-1.3" = mkJenkinsPlugin {
    name = "distfork-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/distfork/1.3/distfork.hpi";
      sha256 = "19xgw1s5942x8cfkqr3sv170nbwr91knlbpj08xacf4xcpjb7akd";
    };
  };
  "docker-build-publish-1.1" = mkJenkinsPlugin {
    name = "docker-build-publish-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/docker-build-publish/1.1/docker-build-publish.hpi";
      sha256 = "0y7007idq8zngf0v0g02lkx05i940fsc162c2ff8sc58q3vip4i3";
    };
  };
  "docker-build-step-1.33" = mkJenkinsPlugin {
    name = "docker-build-step-1.33";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/docker-build-step/1.33/docker-build-step.hpi";
      sha256 = "0chwjncjbx27lbxarnzlrky8wia6h5xja67nal4ac4a9h69cqipx";
    };
  };
  "docker-commons-1.2" = mkJenkinsPlugin {
    name = "docker-commons-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/docker-commons/1.2/docker-commons.hpi";
      sha256 = "0bad7xc7rzscclrsjjvjwamnw253s8521k3gzcf1nx2c7cwfdk72";
    };
  };
  "docker-custom-build-environment-1.6.4" = mkJenkinsPlugin {
    name = "docker-custom-build-environment-1.6.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/docker-custom-build-environment/1.6.4/docker-custom-build-environment.hpi";
      sha256 = "1i8vkxymf3cl82s5sllvzfk4x9bsnak8qzlx4g07rf6d3rqfg30k";
    };
  };
  "docker-plugin-0.16.0" = mkJenkinsPlugin {
    name = "docker-plugin-0.16.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/docker-plugin/0.16.0/docker-plugin.hpi";
      sha256 = "1d6lx8mpnk27qra2s9qmkdm02qq5lbg0xgwn288basdp8gfriv0z";
    };
  };
  "docker-traceability-1.1" = mkJenkinsPlugin {
    name = "docker-traceability-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/docker-traceability/1.1/docker-traceability.hpi";
      sha256 = "02yhf8raf310ywxrnmqlj2k99sipv5rgmxya3vyann2kbxqhyfpy";
    };
  };
  "docker-workflow-1.2" = mkJenkinsPlugin {
    name = "docker-workflow-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/docker-workflow/1.2/docker-workflow.hpi";
      sha256 = "00gyhzz36lfndkali40101zrg87jr2nhdr2hgp2b0nixlwp7hp2x";
    };
  };
  "dockerhub-notification-1.0.2" = mkJenkinsPlugin {
    name = "dockerhub-notification-1.0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/dockerhub-notification/1.0.2/dockerhub-notification.hpi";
      sha256 = "0g7ik34j4xqpzdcq1s92626cwy634024r8bfldhz7wjwhn13s6xd";
    };
  };
  "doclinks-0.6" = mkJenkinsPlugin {
    name = "doclinks-0.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/doclinks/0.6/doclinks.hpi";
      sha256 = "1d27vv6qlx71lil7iqm6nxry7wl5g4jzyfcgp1667rs0zgckmcgd";
    };
  };
  "dos-trigger-1.23" = mkJenkinsPlugin {
    name = "dos-trigger-1.23";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/dos-trigger/1.23/dos-trigger.hpi";
      sha256 = "12zx0yy0w3p8rd6gbhw6rzz1y0lix9jcz74vh7k0ahyylhvx6y27";
    };
  };
  "downstream-buildview-1.9" = mkJenkinsPlugin {
    name = "downstream-buildview-1.9";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/downstream-buildview/1.9/downstream-buildview.hpi";
      sha256 = "0g6fir14p6g6ri5fmji73mv8hfi6qsl0h74v72klp9bk29v6i6g0";
    };
  };
  "downstream-ext-1.8" = mkJenkinsPlugin {
    name = "downstream-ext-1.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/downstream-ext/1.8/downstream-ext.hpi";
      sha256 = "00h2gwbp82ynfvsmnd0daqp29nwpv74bbginrhm4i5mbyci4yqhl";
    };
  };
  "doxygen-0.18" = mkJenkinsPlugin {
    name = "doxygen-0.18";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/doxygen/0.18/doxygen.hpi";
      sha256 = "1zg0rqiwcfj113zzjfv4qfgz5wj0agnfyjqpclqj0h1b2ld33vpi";
    };
  };
  "drmemory-plugin-1.4" = mkJenkinsPlugin {
    name = "drmemory-plugin-1.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/drmemory-plugin/1.4/drmemory-plugin.hpi";
      sha256 = "15aakxmdha6j5a9dbn6say9axi1plr2ajknvxv189ng7j5c1qlrr";
    };
  };
  "dropdown-viewstabbar-plugin-1.7" = mkJenkinsPlugin {
    name = "dropdown-viewstabbar-plugin-1.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/dropdown-viewstabbar-plugin/1.7/dropdown-viewstabbar-plugin.hpi";
      sha256 = "1akf38304zjpb2f7xzxdh5ad066mkc7cmjmz3vzi5h6lf2fy5kah";
    };
  };
  "drupal-developer-0.6" = mkJenkinsPlugin {
    name = "drupal-developer-0.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/drupal-developer/0.6/drupal-developer.hpi";
      sha256 = "0i24sha80067j7rz8nfh08vryn0cfjfp26pxn3yrkffma58h857j";
    };
  };
  "dry-run-0.9" = mkJenkinsPlugin {
    name = "dry-run-0.9";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/dry-run/0.9/dry-run.hpi";
      sha256 = "04y5v1j3dl1h65jzd4v5p36bbvwk1bydsk9mbgck23w71b4gfwz9";
    };
  };
  "dry-2.43" = mkJenkinsPlugin {
    name = "dry-2.43";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/dry/2.43/dry.hpi";
      sha256 = "1fac5pam6v77s2ij0yl0w2xf3fg9vxrdlmcfw159phzrm8apwgqx";
    };
  };
  "dtkit-2.1.3" = mkJenkinsPlugin {
    name = "dtkit-2.1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/dtkit/2.1.3/dtkit.hpi";
      sha256 = "00kkndih03k4scdzjzdj4yfv34kq8m6438wk2jndlvracnpgr2f1";
    };
  };
  "dumpinfo-buildwrapper-plugin-1.1" = mkJenkinsPlugin {
    name = "dumpinfo-buildwrapper-plugin-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/dumpinfo-buildwrapper-plugin/1.1/dumpinfo-buildwrapper-plugin.hpi";
      sha256 = "1116l56qwk96wgdp81bj93qmd031qwf7qha215qxlyf3b84j3wmz";
    };
  };
  "dumpling-1.0" = mkJenkinsPlugin {
    name = "dumpling-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/dumpling/1.0/dumpling.hpi";
      sha256 = "1f6zsxbrf47vgiamsp3dsqvhqj5k3hfpzs1rv2zf6g56lkq34wmi";
    };
  };
  "durable-task-1.7" = mkJenkinsPlugin {
    name = "durable-task-1.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/durable-task/1.7/durable-task.hpi";
      sha256 = "1bhfxzfb6nlwscvqx5cdhynz02jz69bwla8fv2dcdv3589wb7qc0";
    };
  };
  "dynamic-axis-1.0.3" = mkJenkinsPlugin {
    name = "dynamic-axis-1.0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/dynamic-axis/1.0.3/dynamic-axis.hpi";
      sha256 = "1mg89nss2xlf2rfxc8zsam075jy4ga1gzfx9ny25a0d6rmdngxbk";
    };
  };
  "dynamic-search-view-0.2.2" = mkJenkinsPlugin {
    name = "dynamic-search-view-0.2.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/dynamic-search-view/0.2.2/dynamic-search-view.hpi";
      sha256 = "0kr7j1a9b79r233zcc09kj4ckf1k17q8gnqrrk41qsdrwyz3ncv0";
    };
  };
  "dynamic_extended_choice_parameter-1.0.1" = mkJenkinsPlugin {
    name = "dynamic_extended_choice_parameter-1.0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/dynamic_extended_choice_parameter/1.0.1/dynamic_extended_choice_parameter.hpi";
      sha256 = "14wjrwcw3w4x59jsqb7cs5b6bjknj07d79bc1bxyfsha5a59nir3";
    };
  };
  "dynamicparameter-0.2.0" = mkJenkinsPlugin {
    name = "dynamicparameter-0.2.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/dynamicparameter/0.2.0/dynamicparameter.hpi";
      sha256 = "1h5wi03camij8jw09xhymacg11r3fwvygpvr625lvkr0anx5i9kv";
    };
  };
  "dynatrace-dashboard-1.0.5" = mkJenkinsPlugin {
    name = "dynatrace-dashboard-1.0.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/dynatrace-dashboard/1.0.5/dynatrace-dashboard.hpi";
      sha256 = "01zkaqwbr3iqnsypygk0i2y205nxzqjn14kmsm8yscwm0c9x7abg";
    };
  };
  "ease-plugin-1.2.10" = mkJenkinsPlugin {
    name = "ease-plugin-1.2.10";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ease-plugin/1.2.10/ease-plugin.hpi";
      sha256 = "0zdxqm8kh652v9b4g9rms8fq53lzngcd85rvw8wl5cr83609jlij";
    };
  };
  "easyant-1.1" = mkJenkinsPlugin {
    name = "easyant-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/easyant/1.1/easyant.hpi";
      sha256 = "0phcxaj3dyhc79j0db4r97ib3l9v51xjfhb4wp2ml8a95iqa9yyy";
    };
  };
  "ec2-cloud-axis-1.2" = mkJenkinsPlugin {
    name = "ec2-cloud-axis-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ec2-cloud-axis/1.2/ec2-cloud-axis.hpi";
      sha256 = "1rr4nas4p40jh6qdx7h5sllp1chvfjg76slnvifn7ycad1fakaak";
    };
  };
  "ec2-deployment-dashboard-1.0.10" = mkJenkinsPlugin {
    name = "ec2-deployment-dashboard-1.0.10";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ec2-deployment-dashboard/1.0.10/ec2-deployment-dashboard.hpi";
      sha256 = "17hipdrj6cp8scr7375481f1faxhrf9mmydw5haidgbnzwgf7rn5";
    };
  };
  "ec2-1.31" = mkJenkinsPlugin {
    name = "ec2-1.31";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ec2/1.31/ec2.hpi";
      sha256 = "0rgapi6sfl2rbj771x0grm1c5fa9kcvkkdjx4w57s1q3w48gxsf1";
    };
  };
  "eclipse-update-site-1.2" = mkJenkinsPlugin {
    name = "eclipse-update-site-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/eclipse-update-site/1.2/eclipse-update-site.hpi";
      sha256 = "1i9fys58fjyjyjpzsgkw2lknywhd5aihaz443sanm1v6dpazip5f";
    };
  };
  "ecutest-1.6" = mkJenkinsPlugin {
    name = "ecutest-1.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ecutest/1.6/ecutest.hpi";
      sha256 = "016dlrhyjgfvih7b80q7ykqpp4vv8crzr6b43747yjqn82kg298g";
    };
  };
  "eggplant-plugin-2.2" = mkJenkinsPlugin {
    name = "eggplant-plugin-2.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/eggplant-plugin/2.2/eggplant-plugin.hpi";
      sha256 = "01mqs2sqfj564difwp02gf0cax3yi86flj4ixn0yf7zb1fz1arn2";
    };
  };
  "elOyente-1.3" = mkJenkinsPlugin {
    name = "elOyente-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/elOyente/1.3/elOyente.hpi";
      sha256 = "09xrdg26ga79z6i5rck3mflh30sgcs6229wx0mrab7608jx0xbly";
    };
  };
  "elastic-axis-1.2" = mkJenkinsPlugin {
    name = "elastic-axis-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/elastic-axis/1.2/elastic-axis.hpi";
      sha256 = "193d6n5lv6d8wgbv033dll2jxf15shhvcpdizval546nfm8pc0r6";
    };
  };
  "elasticbox-4.0.3" = mkJenkinsPlugin {
    name = "elasticbox-4.0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/elasticbox/4.0.3/elasticbox.hpi";
      sha256 = "1r43f00s9ljm0x9qh3g8hz665ijlgaj6wrr5qymmwngvx750g94f";
    };
  };
  "elasticsearch-query-1.2" = mkJenkinsPlugin {
    name = "elasticsearch-query-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/elasticsearch-query/1.2/elasticsearch-query.hpi";
      sha256 = "10gwb4zfkxh52vmwjz11948ydppmpm22lzfmafy068hh03w204rc";
    };
  };
  "email-ext-recipients-column-1.0" = mkJenkinsPlugin {
    name = "email-ext-recipients-column-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/email-ext-recipients-column/1.0/email-ext-recipients-column.hpi";
      sha256 = "02rxhah2rpv0wvqn2cs9xigrr3x50wfi1ap3d0imxkm9m44yfl8y";
    };
  };
  "email-ext-2.40.5" = mkJenkinsPlugin {
    name = "email-ext-2.40.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/email-ext/2.40.5/email-ext.hpi";
      sha256 = "05cqwvlr0js0v3p1qjqpdm0yypqz2ifjdi7c32x40v1l7crdbml5";
    };
  };
  "emailext-template-0.4" = mkJenkinsPlugin {
    name = "emailext-template-0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/emailext-template/0.4/emailext-template.hpi";
      sha256 = "0mqiwcaxhjc24i9l8divs3fx9bji58si3y5d4lnnckivw31q697x";
    };
  };
  "embeddable-build-status-1.8" = mkJenkinsPlugin {
    name = "embeddable-build-status-1.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/embeddable-build-status/1.8/embeddable-build-status.hpi";
      sha256 = "1jhkcigx8xcmj498q0s3ja8ji9vpmdw9kg52b5jg2xi3w3jbpxyz";
    };
  };
  "emma-1.29" = mkJenkinsPlugin {
    name = "emma-1.29";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/emma/1.29/emma.hpi";
      sha256 = "17vhzj961b35ylsq0b0d0fd3hd7jpkh62wbl9rlp1x8qyzm4fyhh";
    };
  };
  "emmacoveragecolumn-0.0.4" = mkJenkinsPlugin {
    name = "emmacoveragecolumn-0.0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/emmacoveragecolumn/0.0.4/emmacoveragecolumn.hpi";
      sha256 = "1ma6al3g48bzf0jls2siq2r042b3hm6slrqgyzww4axs599p7lrl";
    };
  };
  "emotional-jenkins-plugin-1.2" = mkJenkinsPlugin {
    name = "emotional-jenkins-plugin-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/emotional-jenkins-plugin/1.2/emotional-jenkins-plugin.hpi";
      sha256 = "0pzws2c024qs7gv2ss3ywj41glf3qywdb1jyrq2wn2pqzp0r4rx1";
    };
  };
  "enhanced-old-build-discarder-1.0" = mkJenkinsPlugin {
    name = "enhanced-old-build-discarder-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/enhanced-old-build-discarder/1.0/enhanced-old-build-discarder.hpi";
      sha256 = "06dl11km5j721qhx8m97g1gy0afpf0p2hc5zg7vbzb16c41hi0rj";
    };
  };
  "envfile-1.2" = mkJenkinsPlugin {
    name = "envfile-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/envfile/1.2/envfile.hpi";
      sha256 = "0sgwsh2drgwwpq03lzmaxrzxxi67kv26m38z11afmiq1kwyrx51x";
    };
  };
  "envinject-1.92.1" = mkJenkinsPlugin {
    name = "envinject-1.92.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/envinject/1.92.1/envinject.hpi";
      sha256 = "19j417vavmk9wbjhvsbignfxsln10jzr2k9jjmp0cbxkrd7xrijw";
    };
  };
  "environment-dashboard-1.1.4" = mkJenkinsPlugin {
    name = "environment-dashboard-1.1.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/environment-dashboard/1.1.4/environment-dashboard.hpi";
      sha256 = "071yb6wpgwmfj1yaj58my8vwpii3gxfflygw0kg885ggv1x11s9s";
    };
  };
  "environment-labels-setter-1.1" = mkJenkinsPlugin {
    name = "environment-labels-setter-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/environment-labels-setter/1.1/environment-labels-setter.hpi";
      sha256 = "1klyjvzdznni92bmp2axyjz21vc4q7i8rmrxcqyqwjn5d158kb4f";
    };
  };
  "environment-script-1.2.2" = mkJenkinsPlugin {
    name = "environment-script-1.2.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/environment-script/1.2.2/environment-script.hpi";
      sha256 = "08isk5agqwsq3b80drnc5md0pdm1lihxkqfz02pziraa64rrrp6f";
    };
  };
  "escaped-markup-plugin-0.1" = mkJenkinsPlugin {
    name = "escaped-markup-plugin-0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/escaped-markup-plugin/0.1/escaped-markup-plugin.hpi";
      sha256 = "0bkjgnwjvygifwpvqgh89sw3gk2z0z01dklqp758p0hzwhw85716";
    };
  };
  "excludeMatrixParent-1.1" = mkJenkinsPlugin {
    name = "excludeMatrixParent-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/excludeMatrixParent/1.1/excludeMatrixParent.hpi";
      sha256 = "1p1n8dbi1zcv4b8nlzmxfynf9wpphw0yk8py3m19gqjjbbyllwyb";
    };
  };
  "exclusive-execution-0.8" = mkJenkinsPlugin {
    name = "exclusive-execution-0.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/exclusive-execution/0.8/exclusive-execution.hpi";
      sha256 = "1x12xv5d6vv5av1mcnzj208hbbja98183936941awjcqiqglck0d";
    };
  };
  "exclusive-label-plugin-1.0" = mkJenkinsPlugin {
    name = "exclusive-label-plugin-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/exclusive-label-plugin/1.0/exclusive-label-plugin.hpi";
      sha256 = "0wcl62fz5y1idniwnprn0i10h3v9mrlxcf7wcg3hklk2kq2xd5lm";
    };
  };
  "export-params-1.1" = mkJenkinsPlugin {
    name = "export-params-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/export-params/1.1/export-params.hpi";
      sha256 = "0yk12wl5xcqgjsvnzaqg1yrgn516b5li809ggqhv0lljyy6hl4wy";
    };
  };
  "extended-choice-parameter-0.56" = mkJenkinsPlugin {
    name = "extended-choice-parameter-0.56";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/extended-choice-parameter/0.56/extended-choice-parameter.hpi";
      sha256 = "10gf9x29v4mgzi6qw761n1fqr53f7wvd0l6fn9xlqyzz5a4fz58j";
    };
  };
  "extended-read-permission-1.0" = mkJenkinsPlugin {
    name = "extended-read-permission-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/extended-read-permission/1.0/extended-read-permission.hpi";
      sha256 = "19c4v83qa16343nr5rq7cbrx0jqbvsnn9a0xvkjjf6m2ywmv0yw2";
    };
  };
  "extensible-choice-parameter-1.3.2" = mkJenkinsPlugin {
    name = "extensible-choice-parameter-1.3.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/extensible-choice-parameter/1.3.2/extensible-choice-parameter.hpi";
      sha256 = "1bhvzy6vf891v1hr5mvs1ibj6fm13h4jmqbnzn58anjzhfc23jkk";
    };
  };
  "extension-filter-1.0" = mkJenkinsPlugin {
    name = "extension-filter-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/extension-filter/1.0/extension-filter.hpi";
      sha256 = "09ngqzbf0w3ni61q6m1mfp1krwpg2g17zfszw41mqqppsdxgk0lz";
    };
  };
  "external-monitor-job-1.4" = mkJenkinsPlugin {
    name = "external-monitor-job-1.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/external-monitor-job/1.4/external-monitor-job.hpi";
      sha256 = "12rxzfsy0z6qhqj14iw23xv8b0msjw5g6kd4g9q4ph42pflfa47v";
    };
  };
  "external-scheduler-1.0" = mkJenkinsPlugin {
    name = "external-scheduler-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/external-scheduler/1.0/external-scheduler.hpi";
      sha256 = "0d9vkwb63dx40ynixb24pz4ll6hxdqxakvsh78y263dhlahr9jf4";
    };
  };
  "externalresource-dispatcher-1.1.0" = mkJenkinsPlugin {
    name = "externalresource-dispatcher-1.1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/externalresource-dispatcher/1.1.0/externalresource-dispatcher.hpi";
      sha256 = "0snbbaxm1rsfpplwz6r77bza7i9h9d7hjz942iy9yyxfkcj2a0a5";
    };
  };
  "extra-columns-1.16" = mkJenkinsPlugin {
    name = "extra-columns-1.16";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/extra-columns/1.16/extra-columns.hpi";
      sha256 = "142ql2whp0rf7ngiwk8xlmr56935vm8c47hyvjyqnnnfgrp7c19n";
    };
  };
  "extra-tool-installers-0.3" = mkJenkinsPlugin {
    name = "extra-tool-installers-0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/extra-tool-installers/0.3/extra-tool-installers.hpi";
      sha256 = "1rbi9ha1x32hiq0jpahf8yzya4kpcrm1p8khd5djxa56lld54gwg";
    };
  };
  "extreme-feedback-1.7" = mkJenkinsPlugin {
    name = "extreme-feedback-1.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/extreme-feedback/1.7/extreme-feedback.hpi";
      sha256 = "0lp524xs3ysra98hd1r8c2kbj0kfliqs3fjmaqbjzh70qafxwkj1";
    };
  };
  "extreme-notification-1.1" = mkJenkinsPlugin {
    name = "extreme-notification-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/extreme-notification/1.1/extreme-notification.hpi";
      sha256 = "1zwzwxxm3rgsklfk3piib57lmm7lpl9128f3f7h7r3glydzq95sc";
    };
  };
  "ez-templates-1.1.2" = mkJenkinsPlugin {
    name = "ez-templates-1.1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ez-templates/1.1.2/ez-templates.hpi";
      sha256 = "0p7831szfq43g0pzhkdh5g41x46hbm316sh4i608jn1d3ivb23am";
    };
  };
  "ezwall-0.3" = mkJenkinsPlugin {
    name = "ezwall-0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ezwall/0.3/ezwall.hpi";
      sha256 = "0n4m59bxc3qiqd02jzh6i97s2zm3r1bi2ykqm6rb7g86v5x51i9d";
    };
  };
  "fail-the-build-plugin-1.0" = mkJenkinsPlugin {
    name = "fail-the-build-plugin-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/fail-the-build-plugin/1.0/fail-the-build-plugin.hpi";
      sha256 = "17nhnydp0i84s4n29vn2kbfbqjgvkcd01lkp1dw6kwpyqqnv0zf9";
    };
  };
  "failedJobDeactivator-1.2.1" = mkJenkinsPlugin {
    name = "failedJobDeactivator-1.2.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/failedJobDeactivator/1.2.1/failedJobDeactivator.hpi";
      sha256 = "1bqw7pxamz04qcninnjglc5kwkdq3sm4slhpi88w4dxhn6xrwaca";
    };
  };
  "favorite-view-1.0" = mkJenkinsPlugin {
    name = "favorite-view-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/favorite-view/1.0/favorite-view.hpi";
      sha256 = "1wjrb0imhkwamv2482798vvbvklk3xfjnhhrqyxkacxzc3flh7f9";
    };
  };
  "favorite-1.16" = mkJenkinsPlugin {
    name = "favorite-1.16";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/favorite/1.16/favorite.hpi";
      sha256 = "18s5jsah2rkzhqgl7w4d38cdskgd4hv3p3kzw84khmkm887yaifs";
    };
  };
  "feature-branch-notifier-1.4" = mkJenkinsPlugin {
    name = "feature-branch-notifier-1.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/feature-branch-notifier/1.4/feature-branch-notifier.hpi";
      sha256 = "1m3vxf1m6qm2hyqfajha9zidmq1lkpxah0d3s1bi1n65s21hlbr0";
    };
  };
  "figlet-buildstep-0.2" = mkJenkinsPlugin {
    name = "figlet-buildstep-0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/figlet-buildstep/0.2/figlet-buildstep.hpi";
      sha256 = "01szia5rbfix334c8wns465lxlbr9amxnz6agl6gfdf88fp7kvsc";
    };
  };
  "file-leak-detector-1.4" = mkJenkinsPlugin {
    name = "file-leak-detector-1.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/file-leak-detector/1.4/file-leak-detector.hpi";
      sha256 = "1ylamw7122b2pf3cz3j7bbfd0xk36a9yw8qhwvc4jxb5ycs4cn9a";
    };
  };
  "files-found-trigger-1.4" = mkJenkinsPlugin {
    name = "files-found-trigger-1.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/files-found-trigger/1.4/files-found-trigger.hpi";
      sha256 = "0c3fc6nrxplmgh9s6f2zyksf6klipff0nh58jq7r6c7k26alv2mw";
    };
  };
  "filesystem-list-parameter-plugin-0.0.3" = mkJenkinsPlugin {
    name = "filesystem-list-parameter-plugin-0.0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/filesystem-list-parameter-plugin/0.0.3/filesystem-list-parameter-plugin.hpi";
      sha256 = "03ln0rrryzzyd24qs9msgjxn0sjzyn99cd4g3vf12n0mxb1jgd5d";
    };
  };
  "filesystem_scm-1.20" = mkJenkinsPlugin {
    name = "filesystem_scm-1.20";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/filesystem_scm/1.20/filesystem_scm.hpi";
      sha256 = "1xq62pr6nv6slp9nbwz0xhxrl543wlxz6hyxw0ghqi43d1g3xd20";
    };
  };
  "findbugs-4.63" = mkJenkinsPlugin {
    name = "findbugs-4.63";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/findbugs/4.63/findbugs.hpi";
      sha256 = "17lbnmyirvv6f6jbik9lxylk29jijjr4ldi6r4q05xkbpa3471if";
    };
  };
  "fitnesse-1.16" = mkJenkinsPlugin {
    name = "fitnesse-1.16";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/fitnesse/1.16/fitnesse.hpi";
      sha256 = "0i997qzpcf1ghjfdy1kf8y93gx9wrsb82kl6jpczfajr3cmy45bj";
    };
  };
  "flaky-test-handler-1.0.4" = mkJenkinsPlugin {
    name = "flaky-test-handler-1.0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/flaky-test-handler/1.0.4/flaky-test-handler.hpi";
      sha256 = "0z4xpljcpys908khy9f51fl070ymhgpjfkxmnk58p22b3qpws7wm";
    };
  };
  "flashlog-plugin-1.0" = mkJenkinsPlugin {
    name = "flashlog-plugin-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/flashlog-plugin/1.0/flashlog-plugin.hpi";
      sha256 = "07im82k02nc80fs37ji6b579j1capyynl2rv99k4w8cnxb2pqvnx";
    };
  };
  "flexible-publish-0.15.2" = mkJenkinsPlugin {
    name = "flexible-publish-0.15.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/flexible-publish/0.15.2/flexible-publish.hpi";
      sha256 = "154q1iyrw0kp0sccxwl590xjz7wmcswrhskj54283y2avp79p63y";
    };
  };
  "flow-1.3" = mkJenkinsPlugin {
    name = "flow-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/flow/1.3/flow.hpi";
      sha256 = "07vmvb1p69jvmvbm0z01fayizafwm9j1n7vawxnzl744dshw1qir";
    };
  };
  "fogbugz-2.2.17" = mkJenkinsPlugin {
    name = "fogbugz-2.2.17";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/fogbugz/2.2.17/fogbugz.hpi";
      sha256 = "1si7lscn06r0dl3bqxyj0y6n5yvy7phfar56mjxz44594x83mpqc";
    };
  };
  "form-element-path-1.5" = mkJenkinsPlugin {
    name = "form-element-path-1.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/form-element-path/1.5/form-element-path.hpi";
      sha256 = "0qmlzknlzbncfb6bcqn30gzr8a53d9kkbqyvi68sc951npab8v6r";
    };
  };
  "fortify-cloudscan-jenkins-plugin-1.1.1" = mkJenkinsPlugin {
    name = "fortify-cloudscan-jenkins-plugin-1.1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/fortify-cloudscan-jenkins-plugin/1.1.1/fortify-cloudscan-jenkins-plugin.hpi";
      sha256 = "0pydpslaialzb7c5fnbg0hpljm23hasz35dndvf3g0axa7m8gdjb";
    };
  };
  "fortify360-3.81" = mkJenkinsPlugin {
    name = "fortify360-3.81";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/fortify360/3.81/fortify360.hpi";
      sha256 = "0csf2pfn4njf47yqjxiv8fa9s0g3w50vkk71zn9nvkkqd0wfqrid";
    };
  };
  "fstrigger-0.39" = mkJenkinsPlugin {
    name = "fstrigger-0.39";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/fstrigger/0.39/fstrigger.hpi";
      sha256 = "1x8c08bpd2hdxc0fgg9x3sc0q3piv3dw83pxw7nrd9zxnv8l4bpf";
    };
  };
  "ftppublisher-1.2" = mkJenkinsPlugin {
    name = "ftppublisher-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ftppublisher/1.2/ftppublisher.hpi";
      sha256 = "1c5zs4gyrl1jdh7073y8m9clkl6ma8ziqq8gqr6xjccxk6p9dpw0";
    };
  };
  "fxcop-runner-1.1" = mkJenkinsPlugin {
    name = "fxcop-runner-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/fxcop-runner/1.1/fxcop-runner.hpi";
      sha256 = "1gm0daqwld9pq5b5x7qgdmwh9hjgvvchmf55g3snbvijapp29qfk";
    };
  };
  "gallio-1.8" = mkJenkinsPlugin {
    name = "gallio-1.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/gallio/1.8/gallio.hpi";
      sha256 = "10lsfv145pgwfmdvszzg5r6f3gl5xg5vk600jafkgfryz1zl32gn";
    };
  };
  "gant-1.2" = mkJenkinsPlugin {
    name = "gant-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/gant/1.2/gant.hpi";
      sha256 = "1wm03q57am0h95k4f3jm8vdpfqk8pgr6mvi9i7p8y7xk28w4qnx5";
    };
  };
  "gatling-1.1.1" = mkJenkinsPlugin {
    name = "gatling-1.1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/gatling/1.1.1/gatling.hpi";
      sha256 = "14633g76ykdm3wg3gyqzfahwfbfbh3aykrzzv529axc7nwdjicjf";
    };
  };
  "gcal-0.4" = mkJenkinsPlugin {
    name = "gcal-0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/gcal/0.4/gcal.hpi";
      sha256 = "1mfqs87rslgnrbc4knmfzf4dkb8v6wbdaxifq8ypkvil70hnzp36";
    };
  };
  "gcloud-sdk-0.0.1" = mkJenkinsPlugin {
    name = "gcloud-sdk-0.0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/gcloud-sdk/0.0.1/gcloud-sdk.hpi";
      sha256 = "1akjraa3z1bqig3bxqpr90f1fypfzg9rs9fb9pp1m8zp6xgs2kd6";
    };
  };
  "gcm-notification-1.0" = mkJenkinsPlugin {
    name = "gcm-notification-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/gcm-notification/1.0/gcm-notification.hpi";
      sha256 = "1d0xyhjr03sl4ziic2h0w2iynbrdxfdymi1pc1w852r52471di72";
    };
  };
  "gearman-plugin-0.1.3" = mkJenkinsPlugin {
    name = "gearman-plugin-0.1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/gearman-plugin/0.1.3/gearman-plugin.hpi";
      sha256 = "0qgvvak8nzny53c9wfrv8zhd2q3chvgwn9456sf99m088fa4a6sm";
    };
  };
  "gem-publisher-1.0" = mkJenkinsPlugin {
    name = "gem-publisher-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/gem-publisher/1.0/gem-publisher.hpi";
      sha256 = "1psny0dvzjxlxvqdzwhg6zy7iaspav0q5dha4n3m112ma84fb5bq";
    };
  };
  "gerrit-trigger-2.18.3" = mkJenkinsPlugin {
    name = "gerrit-trigger-2.18.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/gerrit-trigger/2.18.3/gerrit-trigger.hpi";
      sha256 = "0pd1lw7k71vj4az3viki1h1qcb055fimpv7f9cvb987cavr97vhb";
    };
  };
  "ghprb-1.30" = mkJenkinsPlugin {
    name = "ghprb-1.30";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ghprb/1.30/ghprb.hpi";
      sha256 = "0k5zi8lmr6blvkfpm7qmwfsr2kfxagh56fiv56dvd8a2kpa43gf7";
    };
  };
  "git-changelog-1.2" = mkJenkinsPlugin {
    name = "git-changelog-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/git-changelog/1.2/git-changelog.hpi";
      sha256 = "0hi8m1wf0gahws4xcxkcsn8nqvwq4v16rhp78mq6l08fvzh8sbip";
    };
  };
  "git-chooser-alternative-1.1" = mkJenkinsPlugin {
    name = "git-chooser-alternative-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/git-chooser-alternative/1.1/git-chooser-alternative.hpi";
      sha256 = "0577lv080nv95psic9xpfqpv0f4xrqf1zsq72sbc3l3ckk1cg41j";
    };
  };
  "git-client-1.19.2" = mkJenkinsPlugin {
    name = "git-client-1.19.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/git-client/1.19.2/git-client.hpi";
      sha256 = "137a3j77ijpjdr0yj348lsay80z13r2hg68zc7yjqqmimfrpb6bh";
    };
  };
  "git-notes-0.0.4" = mkJenkinsPlugin {
    name = "git-notes-0.0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/git-notes/0.0.4/git-notes.hpi";
      sha256 = "124ajqvdmyjs2z9d0iwxqkccm953500bnb8d1p0bmy7a2kyk3brz";
    };
  };
  "git-parameter-0.4.0" = mkJenkinsPlugin {
    name = "git-parameter-0.4.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/git-parameter/0.4.0/git-parameter.hpi";
      sha256 = "16c884g85mkay9kj7j818jcm883h9wjkjm2i4pxycqg1njyw4l24";
    };
  };
  "git-server-1.6" = mkJenkinsPlugin {
    name = "git-server-1.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/git-server/1.6/git-server.hpi";
      sha256 = "0my6ad7yla7sy9adcg0fl7nq0lvncp237j5f49bcvznl0fk6yw5k";
    };
  };
  "git-tag-message-1.4" = mkJenkinsPlugin {
    name = "git-tag-message-1.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/git-tag-message/1.4/git-tag-message.hpi";
      sha256 = "0v5wrldlgmzy9kcfhbl8f8ir71caj8xvmw9aaqz5sz8kzhihwdcx";
    };
  };
  "git-userContent-1.4" = mkJenkinsPlugin {
    name = "git-userContent-1.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/git-userContent/1.4/git-userContent.hpi";
      sha256 = "04hq6wrf2rx0l843b0igzsw3pp9lq7kv2fb0z5i1la10mya6nxpz";
    };
  };
  "git-2.4.1" = mkJenkinsPlugin {
    name = "git-2.4.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/git/2.4.1/git.hpi";
      sha256 = "0fkh2c0kz3hph5z2aqv6nihg9yr7yqd87ma26pp8ln9s1kf25lra";
    };
  };
  "gitbucket-0.8" = mkJenkinsPlugin {
    name = "gitbucket-0.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/gitbucket/0.8/gitbucket.hpi";
      sha256 = "0ky4hkd1ww4s3rbl544qsmspahqsp2zlgli3akhi5s7mj83c999i";
    };
  };
  "gitcolony-plugin-1.1" = mkJenkinsPlugin {
    name = "gitcolony-plugin-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/gitcolony-plugin/1.1/gitcolony-plugin.hpi";
      sha256 = "1x7dmpa2ipgnxkbjpakjvjb9m4fmpwivr17splnfa34idyr07wwf";
    };
  };
  "github-api-1.72" = mkJenkinsPlugin {
    name = "github-api-1.72";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/github-api/1.72/github-api.hpi";
      sha256 = "1sglxvgr7sw99djnair29pqsfywb7dind3cyvf2blsnr94r7hjsh";
    };
  };
  "github-branch-source-1.1" = mkJenkinsPlugin {
    name = "github-branch-source-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/github-branch-source/1.1/github-branch-source.hpi";
      sha256 = "1zjlrh4yk93hmwrvvfsjkbqjvshaz40f0xmfca0bzfwybiwj9c4q";
    };
  };
  "github-oauth-0.22.2" = mkJenkinsPlugin {
    name = "github-oauth-0.22.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/github-oauth/0.22.2/github-oauth.hpi";
      sha256 = "0blbh254i0qma2izrgz9qhwgvpi2ndsc6xr6xna4qvyb4p6590j4";
    };
  };
  "github-pullrequest-0.0.1-rc3" = mkJenkinsPlugin {
    name = "github-pullrequest-0.0.1-rc3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/github-pullrequest/0.0.1-rc3/github-pullrequest.hpi";
      sha256 = "1wa0rjj02nwn7bwa0rcfmmm0nhhrjqx931ccmwv9kjkipn0iyp6q";
    };
  };
  "github-sqs-plugin-1.5" = mkJenkinsPlugin {
    name = "github-sqs-plugin-1.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/github-sqs-plugin/1.5/github-sqs-plugin.hpi";
      sha256 = "18iii731b8r79rrfs4bcsw24j8rw923296zys92fjnflv04zfi7m";
    };
  };
  "github-1.17.0" = mkJenkinsPlugin {
    name = "github-1.17.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/github/1.17.0/github.hpi";
      sha256 = "0553m91dvg6nghz7a9razzkq1lsz134nfl0kchxqznqg26f4lgh5";
    };
  };
  "gitlab-logo-1.0.1" = mkJenkinsPlugin {
    name = "gitlab-logo-1.0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/gitlab-logo/1.0.1/gitlab-logo.hpi";
      sha256 = "0ixqm9zp4kjdf33y6kh2hf0f0mwwiqsg4vm6srgj6is5vdljgqi9";
    };
  };
  "gitlab-merge-request-jenkins-2.0.0" = mkJenkinsPlugin {
    name = "gitlab-merge-request-jenkins-2.0.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/gitlab-merge-request-jenkins/2.0.0/gitlab-merge-request-jenkins.hpi";
      sha256 = "1nbpkddw4lgygp7f7g8g7mxqp08gz59hcb03ldn9a7nrw8i5682w";
    };
  };
  "gitlab-plugin-1.1.28" = mkJenkinsPlugin {
    name = "gitlab-plugin-1.1.28";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/gitlab-plugin/1.1.28/gitlab-plugin.hpi";
      sha256 = "1jfnp9yx48vycwxfqw2v4mca7z2di5q253wh8j88ff9z9pwhxq54";
    };
  };
  "global-build-stats-1.3" = mkJenkinsPlugin {
    name = "global-build-stats-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/global-build-stats/1.3/global-build-stats.hpi";
      sha256 = "0x07s5ni96lqrz9n9689vh3zs9q05sflssvm8izkk764qkpx9mc3";
    };
  };
  "global-post-script-1.1.0" = mkJenkinsPlugin {
    name = "global-post-script-1.1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/global-post-script/1.1.0/global-post-script.hpi";
      sha256 = "1nbx07ip6ny2ky5z4dg71dy529wvlm54sjdqnjxzzncnzhi2cl0h";
    };
  };
  "global-variable-string-parameter-1.2" = mkJenkinsPlugin {
    name = "global-variable-string-parameter-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/global-variable-string-parameter/1.2/global-variable-string-parameter.hpi";
      sha256 = "110ndh6prb57sgrha3kcncglzpwgv4alcpfrsc3xsydiad44ncpq";
    };
  };
  "gnat-0.14" = mkJenkinsPlugin {
    name = "gnat-0.14";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/gnat/0.14/gnat.hpi";
      sha256 = "1rmh2gnfz7c59qmrahzqrzj4xp7yxynaipzrqgahc4v8v57yp995";
    };
  };
  "golang-1.1" = mkJenkinsPlugin {
    name = "golang-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/golang/1.1/golang.hpi";
      sha256 = "03qvcn2q44jx08ljg9hls04j953yazdqvn4k2gkw599rg4d3z89p";
    };
  };
  "google-analytics-usage-reporter-0.4" = mkJenkinsPlugin {
    name = "google-analytics-usage-reporter-0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/google-analytics-usage-reporter/0.4/google-analytics-usage-reporter.hpi";
      sha256 = "10z9krzi8p3gfdckvykg88i3acza57xf169080zcy8xr8xh5y71m";
    };
  };
  "google-api-client-plugin-2.0-1.20.0" = mkJenkinsPlugin {
    name = "google-api-client-plugin-2.0-1.20.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/google-api-client-plugin/2.0-1.20.0/google-api-client-plugin.hpi";
      sha256 = "05f3g5sl4kvxydp704xnxqsf8alxnvfh87hjpparh4j9ffpzimvm";
    };
  };
  "google-cloud-backup-0.6" = mkJenkinsPlugin {
    name = "google-cloud-backup-0.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/google-cloud-backup/0.6/google-cloud-backup.hpi";
      sha256 = "1brpqz527avm0ifrm8k9mydhwci6riji8xm5a4q3lhmjn5yf9jnz";
    };
  };
  "google-cloud-health-check-0.3" = mkJenkinsPlugin {
    name = "google-cloud-health-check-0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/google-cloud-health-check/0.3/google-cloud-health-check.hpi";
      sha256 = "1zx142bq1gb95vykwwrqxqb71yzh6c74jby7j6776g5lij4cp9xz";
    };
  };
  "google-container-registry-auth-0.3" = mkJenkinsPlugin {
    name = "google-container-registry-auth-0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/google-container-registry-auth/0.3/google-container-registry-auth.hpi";
      sha256 = "0vbpx3z3k121fwzfl51rynqh6dn1pn98k7j2hbybwz0y6q1vxnhb";
    };
  };
  "google-git-notes-publisher-0.3" = mkJenkinsPlugin {
    name = "google-git-notes-publisher-0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/google-git-notes-publisher/0.3/google-git-notes-publisher.hpi";
      sha256 = "1s7sqw39dd67jmyycffzrykcm9wp2531r832q4c7jxl1jg08fay1";
    };
  };
  "google-login-1.2.1" = mkJenkinsPlugin {
    name = "google-login-1.2.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/google-login/1.2.1/google-login.hpi";
      sha256 = "1dkqqhk1yc7v152ci7z9fzv5f4vaa566vdjccd5sn4skkbbsbpqm";
    };
  };
  "google-metadata-plugin-0.2" = mkJenkinsPlugin {
    name = "google-metadata-plugin-0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/google-metadata-plugin/0.2/google-metadata-plugin.hpi";
      sha256 = "0wbyvvd6vlznwwdp1mm46x9swvis2d30brjwsrjxh0i9y5sfjcci";
    };
  };
  "google-oauth-plugin-0.4" = mkJenkinsPlugin {
    name = "google-oauth-plugin-0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/google-oauth-plugin/0.4/google-oauth-plugin.hpi";
      sha256 = "17d574a97saf6zmgfcgggjqs2v8klfp7d7kqnkjx0mfxaj9lnqck";
    };
  };
  "google-play-android-publisher-1.4.1" = mkJenkinsPlugin {
    name = "google-play-android-publisher-1.4.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/google-play-android-publisher/1.4.1/google-play-android-publisher.hpi";
      sha256 = "1dg95b7mas60xx7yq2bx6zp9hv504gnrs5gi3790i0v3mxdqhhd4";
    };
  };
  "google-source-plugin-0.1" = mkJenkinsPlugin {
    name = "google-source-plugin-0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/google-source-plugin/0.1/google-source-plugin.hpi";
      sha256 = "0dky387gmk6zsp4xyvv1z47awxxi7h1y8q123bj930xf1xglnvff";
    };
  };
  "google-storage-plugin-0.9" = mkJenkinsPlugin {
    name = "google-storage-plugin-0.9";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/google-storage-plugin/0.9/google-storage-plugin.hpi";
      sha256 = "1fz46hd6dkbsa53r4r96jlqn8nhwjabll6dmsgpb7fs22kcf34jh";
    };
  };
  "googleanalytics-1.3" = mkJenkinsPlugin {
    name = "googleanalytics-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/googleanalytics/1.3/googleanalytics.hpi";
      sha256 = "16am6g1rnlgb4ch6z99abg9zd4sf001hylh4iliq1p38fbll5xf3";
    };
  };
  "gradle-1.24" = mkJenkinsPlugin {
    name = "gradle-1.24";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/gradle/1.24/gradle.hpi";
      sha256 = "1hdjcjpx13k88qrq3ka31if06ylhabbwkx2v677lmlm26c82nyr8";
    };
  };
  "grails-1.7" = mkJenkinsPlugin {
    name = "grails-1.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/grails/1.7/grails.hpi";
      sha256 = "04sr50wdhda97zf7yi76gzs9hn6hafwkyk12s7qr0prvm4582vj6";
    };
  };
  "graphiteIntegrator-1.2" = mkJenkinsPlugin {
    name = "graphiteIntegrator-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/graphiteIntegrator/1.2/graphiteIntegrator.hpi";
      sha256 = "1zsmhvb67ihwhj436vwq2m3n4vvzp4mvcgdlh44ab8iwxmnb3pbq";
    };
  };
  "gravatar-2.1" = mkJenkinsPlugin {
    name = "gravatar-2.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/gravatar/2.1/gravatar.hpi";
      sha256 = "0mc6kp9yp5qizwg1nd95r0sa47c9j1dvghx493qw5ik9449dvnzf";
    };
  };
  "greenballs-1.15" = mkJenkinsPlugin {
    name = "greenballs-1.15";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/greenballs/1.15/greenballs.hpi";
      sha256 = "1ywn88f1wziyjsv0p29q1yhrh27mgvc126bf4vq4d972kkxj4dvc";
    };
  };
  "grinder-1.4" = mkJenkinsPlugin {
    name = "grinder-1.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/grinder/1.4/grinder.hpi";
      sha256 = "03yj4n73ql7qvqd9bqiwgmnwp3kqg5dahnbk8kfq51bbgffpvgfz";
    };
  };
  "groovy-events-listener-plugin-master-1.007" = mkJenkinsPlugin {
    name = "groovy-events-listener-plugin-master-1.007";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/groovy-events-listener-plugin-master/1.007/groovy-events-listener-plugin-master.hpi";
      sha256 = "1y62nyqpgb6l9jl1430i28wmj63yjc55nsl1r1v3v8ghrhwjnlpa";
    };
  };
  "groovy-events-listener-plugin-1.009" = mkJenkinsPlugin {
    name = "groovy-events-listener-plugin-1.009";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/groovy-events-listener-plugin/1.009/groovy-events-listener-plugin.hpi";
      sha256 = "1877m2nvbpl2nwrp8xni8ccb7mgl2fwzv64y9r76ih5wgpshhn4a";
    };
  };
  "groovy-label-assignment-1.1.1" = mkJenkinsPlugin {
    name = "groovy-label-assignment-1.1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/groovy-label-assignment/1.1.1/groovy-label-assignment.hpi";
      sha256 = "0wjj2aqv506x2flq98m47wwwphdm769ycp0k6540yqnywxkmpyd1";
    };
  };
  "groovy-postbuild-2.3" = mkJenkinsPlugin {
    name = "groovy-postbuild-2.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/groovy-postbuild/2.3/groovy-postbuild.hpi";
      sha256 = "0g2r3d3560a8s7nf12qid070zngjsqs7bxhs0fyd2dc4qjcd1mhf";
    };
  };
  "groovy-remote-0.2" = mkJenkinsPlugin {
    name = "groovy-remote-0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/groovy-remote/0.2/groovy-remote.hpi";
      sha256 = "0x1y0rgvg7xflb8mpd8iynr8qma5s43if4v6y3c9j2zr62gvc2h7";
    };
  };
  "groovy-1.29" = mkJenkinsPlugin {
    name = "groovy-1.29";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/groovy/1.29/groovy.hpi";
      sha256 = "0m720hah51zin25n4gi5yldkijzfw17npa2bb4szwqz2968pdww7";
    };
  };
  "groovyaxis-0.3" = mkJenkinsPlugin {
    name = "groovyaxis-0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/groovyaxis/0.3/groovyaxis.hpi";
      sha256 = "18q03cnfzwdxbldclkcl57fpzqfchhy2f1g6iwrfxls8kdsdzwnr";
    };
  };
  "growl-1.1" = mkJenkinsPlugin {
    name = "growl-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/growl/1.1/growl.hpi";
      sha256 = "1diivqkhwkhmaidyg0lvzdqyq3cj12bfh9qa8xskq8yc80n3qaqf";
    };
  };
  "hadoop-1.4" = mkJenkinsPlugin {
    name = "hadoop-1.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/hadoop/1.4/hadoop.hpi";
      sha256 = "18fhibgcp22kc261b07572x3a1qb37qz3kh3jk24vwww82gkh6kl";
    };
  };
  "handlebars-1.1" = mkJenkinsPlugin {
    name = "handlebars-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/handlebars/1.1/handlebars.hpi";
      sha256 = "1r53y9icahqcy7ijy3jc76qhq6105adpg6fm764nsywg2pzjpbqc";
    };
  };
  "harvest-0.5.1" = mkJenkinsPlugin {
    name = "harvest-0.5.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/harvest/0.5.1/harvest.hpi";
      sha256 = "0khzj2ym745s7ii8a5qbpw9ddli06ysyczy25h8jdwk8icrkdydi";
    };
  };
  "hckrnews-1.1" = mkJenkinsPlugin {
    name = "hckrnews-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/hckrnews/1.1/hckrnews.hpi";
      sha256 = "1cxgv52ap4a9xv9311p1kp6jz3xycqpavn5knqibl1q6k3bqma1i";
    };
  };
  "heavy-job-1.1" = mkJenkinsPlugin {
    name = "heavy-job-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/heavy-job/1.1/heavy-job.hpi";
      sha256 = "1i29b1hfkrm5gvkfqwkk0mqxb2hmhyqgq3ws5yzp28rw2na4jccj";
    };
  };
  "heroku-jenkins-plugin-0.7.1-BETA" = mkJenkinsPlugin {
    name = "heroku-jenkins-plugin-0.7.1-BETA";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/heroku-jenkins-plugin/0.7.1-BETA/heroku-jenkins-plugin.hpi";
      sha256 = "0qvs325i9fcyjg5sh3x47srfywr0p63wfkfar6k6cfh4qrfc5ssv";
    };
  };
  "hgca-1.3" = mkJenkinsPlugin {
    name = "hgca-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/hgca/1.3/hgca.hpi";
      sha256 = "033dgpx46j7hv1hbl2g0yf7rkdq0lv67r948ca494igkw9arqnws";
    };
  };
  "hidden-parameter-0.0.4" = mkJenkinsPlugin {
    name = "hidden-parameter-0.0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/hidden-parameter/0.0.4/hidden-parameter.hpi";
      sha256 = "0g0l3s7h9q1lrpxrpphrz3dyqhhq88x2gb41yjary3ki93ivdq3z";
    };
  };
  "hipchat-1.0.0" = mkJenkinsPlugin {
    name = "hipchat-1.0.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/hipchat/1.0.0/hipchat.hpi";
      sha256 = "1nvz4khvlbgj6n8klxci9fhxblyc7534c3g4zfcxbfnw5v2wzhi1";
    };
  };
  "hockeyapp-1.2.0" = mkJenkinsPlugin {
    name = "hockeyapp-1.2.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/hockeyapp/1.2.0/hockeyapp.hpi";
      sha256 = "1h94d1vmhzjsqscmkrhrmqbqpv25qc0ya3mzk9ch9ldf5gnpw05m";
    };
  };
  "housekeeper-1.1" = mkJenkinsPlugin {
    name = "housekeeper-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/housekeeper/1.1/housekeeper.hpi";
      sha256 = "13d76fr21xis7syzvlq3da0d710vkvyirkq8i61xxj1sd49z6gvq";
    };
  };
  "hp-application-automation-tools-plugin-4.0" = mkJenkinsPlugin {
    name = "hp-application-automation-tools-plugin-4.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/hp-application-automation-tools-plugin/4.0/hp-application-automation-tools-plugin.hpi";
      sha256 = "0c680s7m54171b7d895jnimw2ynsp7sfbzmm86qfhlwnir5djd70";
    };
  };
  "hp-operations-orchestration-automation-execution-plugin-2.0.0" = mkJenkinsPlugin {
    name = "hp-operations-orchestration-automation-execution-plugin-2.0.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/hp-operations-orchestration-automation-execution-plugin/2.0.0/hp-operations-orchestration-automation-execution-plugin.hpi";
      sha256 = "0v1srlvcs6b4kk1qa4x6gsf2pjns3yyzs7mxzvdw1hvxq286v2yz";
    };
  };
  "hsts-filter-plugin-1.0" = mkJenkinsPlugin {
    name = "hsts-filter-plugin-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/hsts-filter-plugin/1.0/hsts-filter-plugin.hpi";
      sha256 = "1xnwbd73k4mz0x839gmk20l812j279j5j6aff8lmbnyg7hg5gih1";
    };
  };
  "html-audio-notifier-0.4" = mkJenkinsPlugin {
    name = "html-audio-notifier-0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/html-audio-notifier/0.4/html-audio-notifier.hpi";
      sha256 = "1pzpqy0xhcxshfq61yb8289m7fhbd3sh0xidj9j2g2mkvsyvrjmd";
    };
  };
  "html5-notifier-plugin-1.5" = mkJenkinsPlugin {
    name = "html5-notifier-plugin-1.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/html5-notifier-plugin/1.5/html5-notifier-plugin.hpi";
      sha256 = "0gvvd86rixcjw7brhddvzr6mfqf4x67yqki51zfch8rrq1x71a8z";
    };
  };
  "htmlpublisher-1.10" = mkJenkinsPlugin {
    name = "htmlpublisher-1.10";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/htmlpublisher/1.10/htmlpublisher.hpi";
      sha256 = "1c112n8yp9fxmx9dhd3j0a0khxg58m6arzjiq4by4zslvdlppgg8";
    };
  };
  "http-post-1.2" = mkJenkinsPlugin {
    name = "http-post-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/http-post/1.2/http-post.hpi";
      sha256 = "1c0hyb8nx4ncymcfakgr9xnrnrd8riakqjsnqpy71bvj041dcwji";
    };
  };
  "http_request-1.8.8" = mkJenkinsPlugin {
    name = "http_request-1.8.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/http_request/1.8.8/http_request.hpi";
      sha256 = "1mh1jhc6d250bp5dlv9vn2g3gmlzz966n1wjzaa5qsf3n64gm10m";
    };
  };
  "hudson-pview-plugin-1.8" = mkJenkinsPlugin {
    name = "hudson-pview-plugin-1.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/hudson-pview-plugin/1.8/hudson-pview-plugin.hpi";
      sha256 = "0w7c0z07b1j5g9axrypp99571xr9nhcs7k5psvkbjnd74isk4lc5";
    };
  };
  "hudson-wsclean-plugin-1.0.5" = mkJenkinsPlugin {
    name = "hudson-wsclean-plugin-1.0.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/hudson-wsclean-plugin/1.0.5/hudson-wsclean-plugin.hpi";
      sha256 = "1y46ih3rv23nn6xdgwljwncr39qwh9ix0rvlnlsdpqldwzi948gk";
    };
  };
  "hudsontrayapp-0.7.3" = mkJenkinsPlugin {
    name = "hudsontrayapp-0.7.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/hudsontrayapp/0.7.3/hudsontrayapp.hpi";
      sha256 = "1dx6ivagvm1jfjzi3w1zy0jz20ha79wbg2c8ap1ag8rhk0sh6mp8";
    };
  };
  "hue-light-1.2.0" = mkJenkinsPlugin {
    name = "hue-light-1.2.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/hue-light/1.2.0/hue-light.hpi";
      sha256 = "1glz81lzamn1x8nczaaf418w7plxjn4s7pvxvrpj97anz6hrn9zc";
    };
  };
  "humbug-0.1.3" = mkJenkinsPlugin {
    name = "humbug-0.1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/humbug/0.1.3/humbug.hpi";
      sha256 = "0fgz822f2igzkl1la5c4ybzmxfp36kigdc0z3xnjpzqw441xbyxg";
    };
  };
  "icescrum-1.0.3" = mkJenkinsPlugin {
    name = "icescrum-1.0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/icescrum/1.0.3/icescrum.hpi";
      sha256 = "1sxy9fb16j7z5166b52kz5m46firp073cl9l1kyhm6cl8zj161qz";
    };
  };
  "icon-shim-2.0.2" = mkJenkinsPlugin {
    name = "icon-shim-2.0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/icon-shim/2.0.2/icon-shim.hpi";
      sha256 = "0ljx25964l56nya6knqjd4whsqwj6vqxsspbw0ks7j19f353w8c1";
    };
  };
  "idobata-notifier-1.0" = mkJenkinsPlugin {
    name = "idobata-notifier-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/idobata-notifier/1.0/idobata-notifier.hpi";
      sha256 = "0wb7g1wbr9yjhfxlrx17q2phcx2xv7rd49n0mq3s8pw29cs5h106";
    };
  };
  "ifttt-build-notifier-1.1" = mkJenkinsPlugin {
    name = "ifttt-build-notifier-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ifttt-build-notifier/1.1/ifttt-build-notifier.hpi";
      sha256 = "18yg15dcllb7vfwvyjkdk5vcd9li8kxg8dfxrglmhv1p0h25c8x1";
    };
  };
  "image-gallery-1.2" = mkJenkinsPlugin {
    name = "image-gallery-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/image-gallery/1.2/image-gallery.hpi";
      sha256 = "1mk6j55pp3kfg46lw7bg05gy269x66rhl66sn70sdr1n6cdr4596";
    };
  };
  "imagecomparison-1.4" = mkJenkinsPlugin {
    name = "imagecomparison-1.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/imagecomparison/1.4/imagecomparison.hpi";
      sha256 = "1mg5rlyibq6vf538in8yfhmj0dqiz1pf2z663xpwi5n5hhwgzjq6";
    };
  };
  "implied-labels-0.5" = mkJenkinsPlugin {
    name = "implied-labels-0.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/implied-labels/0.5/implied-labels.hpi";
      sha256 = "0nw65s3la68dws9lqj864v6q3j0gx3d4cbg6am2ijgvwgxwcgf1y";
    };
  };
  "inedo-buildmaster-1.3" = mkJenkinsPlugin {
    name = "inedo-buildmaster-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/inedo-buildmaster/1.3/inedo-buildmaster.hpi";
      sha256 = "1jr6zzna6xnf8chdinc2b4vdxh060yf1b3sa6mh8q77hj09s7q1w";
    };
  };
  "installshield-1.0.3" = mkJenkinsPlugin {
    name = "installshield-1.0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/installshield/1.0.3/installshield.hpi";
      sha256 = "0w0hqkaz56pbs5mkw30n27707d8gy05pil385v49vgslp9g6b3qz";
    };
  };
  "instant-messaging-1.35" = mkJenkinsPlugin {
    name = "instant-messaging-1.35";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/instant-messaging/1.35/instant-messaging.hpi";
      sha256 = "0hzcp54g9fz7fszzkhw226njlmsxs2h00i4fkk6lzyaaafzpgmm3";
    };
  };
  "integrity-plugin-2.0" = mkJenkinsPlugin {
    name = "integrity-plugin-2.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/integrity-plugin/2.0/integrity-plugin.hpi";
      sha256 = "0x492c5xdhbrnrdas5a9wgbkg4qgbys8c025qk59g1wn3icv33d8";
    };
  };
  "internetmeme-1.0" = mkJenkinsPlugin {
    name = "internetmeme-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/internetmeme/1.0/internetmeme.hpi";
      sha256 = "1zlp9v0lin1694nz1wf8l60hzsnvk40qz2njw5jhps2iq6h90i34";
    };
  };
  "ios-device-connector-1.2" = mkJenkinsPlugin {
    name = "ios-device-connector-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ios-device-connector/1.2/ios-device-connector.hpi";
      sha256 = "13493bxzzrkkxqq1iv3j7rr690zqpl3ldd9vl6qlwz3jxggv5djf";
    };
  };
  "iphoneview-0.2" = mkJenkinsPlugin {
    name = "iphoneview-0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/iphoneview/0.2/iphoneview.hpi";
      sha256 = "1ygnlbm72v53z2cshzq0rjqnm3qr3qjnqdxq9nadnk9chrqhncg9";
    };
  };
  "ipmessenger-plugin-1.2" = mkJenkinsPlugin {
    name = "ipmessenger-plugin-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ipmessenger-plugin/1.2/ipmessenger-plugin.hpi";
      sha256 = "0cc2mgnyn589ij1cb9n4ald4dmh0ck69l9wmhnmiah21pj7304m3";
    };
  };
  "ircbot-2.26" = mkJenkinsPlugin {
    name = "ircbot-2.26";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ircbot/2.26/ircbot.hpi";
      sha256 = "0idsvn192bpvinwj7pbbir8l97qj81kp7ag4yavz8fy7mf7krjx5";
    };
  };
  "ironmq-notifier-1.0.13" = mkJenkinsPlugin {
    name = "ironmq-notifier-1.0.13";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ironmq-notifier/1.0.13/ironmq-notifier.hpi";
      sha256 = "1xr61amxqj9vzis6j03c74ha761233kfc6cw7x5x8375ws5kb810";
    };
  };
  "issue-link-1.0.0" = mkJenkinsPlugin {
    name = "issue-link-1.0.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/issue-link/1.0.0/issue-link.hpi";
      sha256 = "1xh8wdl5g2slkvhdfs56710q41sfmh1kjwh07q3xgs6f1ykcxvzn";
    };
  };
  "itest-1.0" = mkJenkinsPlugin {
    name = "itest-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/itest/1.0/itest.hpi";
      sha256 = "0gjyx832d0v4i0ahp7brxsn3w5y87zf5magkm0zw0kw4sdydkb34";
    };
  };
  "ivy-report-1.2" = mkJenkinsPlugin {
    name = "ivy-report-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ivy-report/1.2/ivy-report.hpi";
      sha256 = "1n8wwlp70kxi0k823g049s8h7rcglq3mrw654y93hrhjxx5prmsj";
    };
  };
  "ivy-1.26" = mkJenkinsPlugin {
    name = "ivy-1.26";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ivy/1.26/ivy.hpi";
      sha256 = "0pc9s8maqdpf58384q5nniiankd4j1h3sla10gv3hg15s5y96sb3";
    };
  };
  "ivytrigger-0.34" = mkJenkinsPlugin {
    name = "ivytrigger-0.34";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ivytrigger/0.34/ivytrigger.hpi";
      sha256 = "1iz0gra0hlzpnaf5nzkdph9wzgjnk17m3fi2kdzknnxz3zjl660q";
    };
  };
  "jabber-server-plugin-1.9" = mkJenkinsPlugin {
    name = "jabber-server-plugin-1.9";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jabber-server-plugin/1.9/jabber-server-plugin.hpi";
      sha256 = "19hs90yqqf3j5nslxyyql1x9hbbjbv4j044pbdps26h68xhsz6zh";
    };
  };
  "jabber-1.35" = mkJenkinsPlugin {
    name = "jabber-1.35";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jabber/1.35/jabber.hpi";
      sha256 = "11gz7x8nijknm3v0rl3wrckg0laix8j2zp9cafnyg10kjvprxzlz";
    };
  };
  "jackson2-api-2.5.4" = mkJenkinsPlugin {
    name = "jackson2-api-2.5.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jackson2-api/2.5.4/jackson2-api.hpi";
      sha256 = "1qsl723qyn4vh5h3ixmhbmgs5hpskc017l32188j8kcxaxx2n29f";
    };
  };
  "jacoco-2.0.1" = mkJenkinsPlugin {
    name = "jacoco-2.0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jacoco/2.0.1/jacoco.hpi";
      sha256 = "09cawd8h9kc75rmdqsggx3sgdqwi62pp9g27jvxm6dq4qlwfdxbz";
    };
  };
  "japex-1.7" = mkJenkinsPlugin {
    name = "japex-1.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/japex/1.7/japex.hpi";
      sha256 = "0y2kbzach32560681fyl59qalyy33sqjvlg9jsbxwh615nvyyhry";
    };
  };
  "javadoc-1.3" = mkJenkinsPlugin {
    name = "javadoc-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/javadoc/1.3/javadoc.hpi";
      sha256 = "1bqmb0xpn39ibjaasd43xqd995q8gf3h1v1y91jnbmi7k1bgnbnd";
    };
  };
  "javancss-1.1" = mkJenkinsPlugin {
    name = "javancss-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/javancss/1.1/javancss.hpi";
      sha256 = "1n3cqklka0g4ypda280wwrpwm50fx0jpb8c8y3zfv09hzwkrnc7c";
    };
  };
  "javatest-report-1.6" = mkJenkinsPlugin {
    name = "javatest-report-1.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/javatest-report/1.6/javatest-report.hpi";
      sha256 = "1kyfn4bidmdjvmqjfrs73mdknympbjwp4bmhmfbnrg49a7s2bl6x";
    };
  };
  "jboss-1.0.5" = mkJenkinsPlugin {
    name = "jboss-1.0.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jboss/1.0.5/jboss.hpi";
      sha256 = "1z4hz02073cz2hxfvlr6xz2crviw5dg7cb5ic0vnadrnqii7k4cx";
    };
  };
  "jbpm-embedded-plugin-0.2" = mkJenkinsPlugin {
    name = "jbpm-embedded-plugin-0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jbpm-embedded-plugin/0.2/jbpm-embedded-plugin.hpi";
      sha256 = "1yr73c17is8viipz66xfvywhpdqzca2b28zxxzp7z3ahs4wrkyji";
    };
  };
  "jbpm-workflow-plugin-0.3" = mkJenkinsPlugin {
    name = "jbpm-workflow-plugin-0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jbpm-workflow-plugin/0.3/jbpm-workflow-plugin.hpi";
      sha256 = "1vm6p5h0a2gkp726619f02psg719sdhjwm0jzi4sx54r9rcim586";
    };
  };
  "jcaptcha-plugin-1.1" = mkJenkinsPlugin {
    name = "jcaptcha-plugin-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jcaptcha-plugin/1.1/jcaptcha-plugin.hpi";
      sha256 = "056dg0xvh04awsjpdy6xllghalvg474n93di2fywbmam0sszmkgy";
    };
  };
  "jclouds-jenkins-2.8.1-1" = mkJenkinsPlugin {
    name = "jclouds-jenkins-2.8.1-1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jclouds-jenkins/2.8.1-1/jclouds-jenkins.hpi";
      sha256 = "0xz4km6gzhxvxvhm80pdx1g2j0kgpinjpb118ag69liy5hiq2w1d";
    };
  };
  "jdepend-1.2.4" = mkJenkinsPlugin {
    name = "jdepend-1.2.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jdepend/1.2.4/jdepend.hpi";
      sha256 = "1wcq0ysawkdz4iwk5w4dvb5k8fdhy999pxig0bc3p5sq8xk2v5kj";
    };
  };
  "jenkins-cloudformation-plugin-1.0" = mkJenkinsPlugin {
    name = "jenkins-cloudformation-plugin-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jenkins-cloudformation-plugin/1.0/jenkins-cloudformation-plugin.hpi";
      sha256 = "1iganh9l7y6swda7yp5r70m3sbm25nl9xl3nlzf1rbdv3wln4h5q";
    };
  };
  "jenkins-flowdock-plugin-1.1.8" = mkJenkinsPlugin {
    name = "jenkins-flowdock-plugin-1.1.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jenkins-flowdock-plugin/1.1.8/jenkins-flowdock-plugin.hpi";
      sha256 = "17p1lvf1sb2yrvc7vvigdzx03iqimz3gdy03yps4czp8lc5ba9fp";
    };
  };
  "jenkins-jira-issue-updater-1.18" = mkJenkinsPlugin {
    name = "jenkins-jira-issue-updater-1.18";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jenkins-jira-issue-updater/1.18/jenkins-jira-issue-updater.hpi";
      sha256 = "1pbk3ry29fgqazasxpmb5c4mcqn3kz1kmd6d4qrf2phvv3ln2jbf";
    };
  };
  "jenkins-multijob-plugin-1.20" = mkJenkinsPlugin {
    name = "jenkins-multijob-plugin-1.20";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jenkins-multijob-plugin/1.20/jenkins-multijob-plugin.hpi";
      sha256 = "07zb9w38qifmfkl0hs1y9aghp8z6y6ybskgn86b4hqd8rwxscjqa";
    };
  };
  "jenkins-reviewbot-2.4.6" = mkJenkinsPlugin {
    name = "jenkins-reviewbot-2.4.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jenkins-reviewbot/2.4.6/jenkins-reviewbot.hpi";
      sha256 = "0s2hp3nnjwsxw9cbvpi7dv1g6p6y7v5vylpbdzyrqc2y5kag8dgg";
    };
  };
  "jenkins-tag-cloud-plugin-1.6" = mkJenkinsPlugin {
    name = "jenkins-tag-cloud-plugin-1.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jenkins-tag-cloud-plugin/1.6/jenkins-tag-cloud-plugin.hpi";
      sha256 = "0fr8m4cs5xciqcmdckp43yck62c4nbcz5bsbi5xnml4aa4yg1nqa";
    };
  };
  "jenkins-testswarm-plugin-1.2" = mkJenkinsPlugin {
    name = "jenkins-testswarm-plugin-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jenkins-testswarm-plugin/1.2/jenkins-testswarm-plugin.hpi";
      sha256 = "0hlwpvm3xavfzkbb8i6ng364y4ik78rlbmlmzylv91fhky7znmzd";
    };
  };
  "jenkinsci-appspider-plugin-1.0.8" = mkJenkinsPlugin {
    name = "jenkinsci-appspider-plugin-1.0.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jenkinsci-appspider-plugin/1.0.8/jenkinsci-appspider-plugin.hpi";
      sha256 = "0cnja6saf8vrngnh1pxs792xhzwxw4p6slr2lzy2zy9s0ij8yjfv";
    };
  };
  "jenkinslint-0.5.0" = mkJenkinsPlugin {
    name = "jenkinslint-0.5.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jenkinslint/0.5.0/jenkinslint.hpi";
      sha256 = "16bim25zrsbq8gmwjglwwcll756hwn21bmnkynmvlx0xl1hj88bw";
    };
  };
  "jenkinswalldisplay-0.6.30" = mkJenkinsPlugin {
    name = "jenkinswalldisplay-0.6.30";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jenkinswalldisplay/0.6.30/jenkinswalldisplay.hpi";
      sha256 = "0wmd3gvvlljdz72wgw1hg6qf3gkahg00gajhi3f4lz4v16p7v21j";
    };
  };
  "jgiven-0.10.0" = mkJenkinsPlugin {
    name = "jgiven-0.10.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jgiven/0.10.0/jgiven.hpi";
      sha256 = "103zf6lr9r68kvm62msghq5fzqyny2lcvqgmnvriaknb49mci7r6";
    };
  };
  "jianliao-1.1" = mkJenkinsPlugin {
    name = "jianliao-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jianliao/1.1/jianliao.hpi";
      sha256 = "0bzfdd3gbv65an5xlwks088vl4byxna3gxx26y07fmzy90a8j3cw";
    };
  };
  "jigomerge-0.8" = mkJenkinsPlugin {
    name = "jigomerge-0.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jigomerge/0.8/jigomerge.hpi";
      sha256 = "0qphymxslfw6mh3xw1fdg2k1d3qgj4li269bz05k04jhvbpyxhnm";
    };
  };
  "jira-ext-0.1" = mkJenkinsPlugin {
    name = "jira-ext-0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jira-ext/0.1/jira-ext.hpi";
      sha256 = "0jvnkyncdp5hc640rqk2il0dajfr638n5whkxpw3njvyrf0hark9";
    };
  };
  "jira-trigger-0.1.0" = mkJenkinsPlugin {
    name = "jira-trigger-0.1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jira-trigger/0.1.0/jira-trigger.hpi";
      sha256 = "1njy1h04zssysgkdjv8zz7d79pzx3fk80v7ykadkxbcbhi7km1lc";
    };
  };
  "jira-2.1" = mkJenkinsPlugin {
    name = "jira-2.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jira/2.1/jira.hpi";
      sha256 = "1cyp8y6r1jazbyn93a0ngcjz9284jfa7vv9iq223g34h49szfarf";
    };
  };
  "job-direct-mail-1.5" = mkJenkinsPlugin {
    name = "job-direct-mail-1.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/job-direct-mail/1.5/job-direct-mail.hpi";
      sha256 = "0vhb0ly0627g6m6lvp6vqfsalqydc9s84x5jfhw5p0iq4rxq1hgr";
    };
  };
  "job-dsl-1.42" = mkJenkinsPlugin {
    name = "job-dsl-1.42";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/job-dsl/1.42/job-dsl.hpi";
      sha256 = "176b4xi998qw7lxrhx7h4gsvip9ymkjy8wdxdiml35yhx5mazrcd";
    };
  };
  "job-exporter-0.4" = mkJenkinsPlugin {
    name = "job-exporter-0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/job-exporter/0.4/job-exporter.hpi";
      sha256 = "18a33zb3aqq3drgq6llhjz9y9lv3xdrpldnqmf6910lmh3apm41b";
    };
  };
  "job-import-plugin-1.2" = mkJenkinsPlugin {
    name = "job-import-plugin-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/job-import-plugin/1.2/job-import-plugin.hpi";
      sha256 = "0vx9xk8l93qiliz11465483msmxqnzfhjaq0mhybyd9dxjyqdxy4";
    };
  };
  "job-log-logger-plugin-1.0" = mkJenkinsPlugin {
    name = "job-log-logger-plugin-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/job-log-logger-plugin/1.0/job-log-logger-plugin.hpi";
      sha256 = "054mj6j66137fh9g1nm48g2a5ysgg0gc0y2g4yrazvgpk304xhlb";
    };
  };
  "job-node-stalker-1.0.5" = mkJenkinsPlugin {
    name = "job-node-stalker-1.0.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/job-node-stalker/1.0.5/job-node-stalker.hpi";
      sha256 = "1ssq7m6w3a2z5v065rx8pa85sna34h54ql5n4snvywga0nhw8qmg";
    };
  };
  "job-parameter-summary-0.3" = mkJenkinsPlugin {
    name = "job-parameter-summary-0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/job-parameter-summary/0.3/job-parameter-summary.hpi";
      sha256 = "0icayvv3w38mgrp5apxbsj014bzb8aha83xdzh3sx8awxgxdca06";
    };
  };
  "job-poll-action-plugin-1.0" = mkJenkinsPlugin {
    name = "job-poll-action-plugin-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/job-poll-action-plugin/1.0/job-poll-action-plugin.hpi";
      sha256 = "1s623d4mz2wr9wwjwildmr609n4z6lbbvkz0s7xpxzyy61lhqjwr";
    };
  };
  "job-restrictions-0.4" = mkJenkinsPlugin {
    name = "job-restrictions-0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/job-restrictions/0.4/job-restrictions.hpi";
      sha256 = "0a258acm42z5a9lszw0hsqb2xx5vz5068mh3avw7v8b6nc2q464a";
    };
  };
  "job-strongauth-simple-0.5" = mkJenkinsPlugin {
    name = "job-strongauth-simple-0.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/job-strongauth-simple/0.5/job-strongauth-simple.hpi";
      sha256 = "1y7ysdl5gr02g3g14qd4ynyw22n1ygr6ybwl1wr2yj6j0rnv959b";
    };
  };
  "jobConfigHistory-2.12" = mkJenkinsPlugin {
    name = "jobConfigHistory-2.12";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jobConfigHistory/2.12/jobConfigHistory.hpi";
      sha256 = "1bsdf2ki6rapxclr8faj29dy6c203vjh0pjlzgnzi09iyxza84za";
    };
  };
  "jobcopy-builder-1.3.0" = mkJenkinsPlugin {
    name = "jobcopy-builder-1.3.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jobcopy-builder/1.3.0/jobcopy-builder.hpi";
      sha256 = "1avvpbyh4kqygg55hmw2x26z8f8csvzv1499vjz85px5rvm6iwlk";
    };
  };
  "jobdelete-builder-1.0" = mkJenkinsPlugin {
    name = "jobdelete-builder-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jobdelete-builder/1.0/jobdelete-builder.hpi";
      sha256 = "0mxd451ly1y32vy5psxrzxgj2af11nh5x0crsi04c536q6q5l7y2";
    };
  };
  "jobgenerator-1.22" = mkJenkinsPlugin {
    name = "jobgenerator-1.22";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jobgenerator/1.22/jobgenerator.hpi";
      sha256 = "1sd90ib6ipimwjkzsvk5ml8pifrb8sibw570ad8ihblxwfc91l4f";
    };
  };
  "jobrequeue-1.0" = mkJenkinsPlugin {
    name = "jobrequeue-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jobrequeue/1.0/jobrequeue.hpi";
      sha256 = "0gqh3n3gqlrcfvp64qswmkq85np8x7343cmafhmvl45pjwvhig9j";
    };
  };
  "jobrevision-0.6" = mkJenkinsPlugin {
    name = "jobrevision-0.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jobrevision/0.6/jobrevision.hpi";
      sha256 = "0z7bddzlg8r6gs0b7011abjl160z823xnagv5mivm03bipfm2711";
    };
  };
  "jobtemplates-1.0" = mkJenkinsPlugin {
    name = "jobtemplates-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jobtemplates/1.0/jobtemplates.hpi";
      sha256 = "1nyfcjrkf6kz40dlzzbrmi3d04cr041cvcdcxyzl687669fdcgav";
    };
  };
  "jobtype-column-1.3" = mkJenkinsPlugin {
    name = "jobtype-column-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jobtype-column/1.3/jobtype-column.hpi";
      sha256 = "108hs4dxp46fyzbckbcz436s3mh4qppx1f58jfrhx9189i303gbm";
    };
  };
  "join-1.16" = mkJenkinsPlugin {
    name = "join-1.16";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/join/1.16/join.hpi";
      sha256 = "1vrr5y9v04lmjhnjlkh6cyg047cafqpyqchc31cjq0b8wf8pabvw";
    };
  };
  "jqs-monitoring-1.4" = mkJenkinsPlugin {
    name = "jqs-monitoring-1.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jqs-monitoring/1.4/jqs-monitoring.hpi";
      sha256 = "1ghcmq38wvcqh8g7pxzb0p7nljqmlmm5a0rkcg8cf9fjcnllm7xz";
    };
  };
  "jquery-detached-1.2" = mkJenkinsPlugin {
    name = "jquery-detached-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jquery-detached/1.2/jquery-detached.hpi";
      sha256 = "0gmp6knggiirm19nirbi2c5dx2g2ggpxhrmi08nfn2977b0rv1n9";
    };
  };
  "jquery-ui-1.0.2" = mkJenkinsPlugin {
    name = "jquery-ui-1.0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jquery-ui/1.0.2/jquery-ui.hpi";
      sha256 = "1lg1a7ha1c8y85sz190nxlv51nm5gjb1vai3nnimzi0wwdnzz2yq";
    };
  };
  "jquery-1.11.2-0" = mkJenkinsPlugin {
    name = "jquery-1.11.2-0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jquery/1.11.2-0/jquery.hpi";
      sha256 = "0aah953x7999qs15a8z8xn0r7jx0yx16y6mmh7biind0sl5r9x5c";
    };
  };
  "jsgames-0.2" = mkJenkinsPlugin {
    name = "jsgames-0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jsgames/0.2/jsgames.hpi";
      sha256 = "1y3h6vvv0iwal3j98q8k4riwrp1b9gqpvxg16zsm4cv04pkky23c";
    };
  };
  "jslint-0.8.2" = mkJenkinsPlugin {
    name = "jslint-0.8.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jslint/0.8.2/jslint.hpi";
      sha256 = "1a1nr21xssym4mdcmw339wb1ipryh0phhn1czqd94g9q63jjlgs8";
    };
  };
  "jsoup-1.6.3" = mkJenkinsPlugin {
    name = "jsoup-1.6.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jsoup/1.6.3/jsoup.hpi";
      sha256 = "1jgpsrq6xlpw19h2dixzyb9qnlfnf7a9mfdh2i2xaq2hia626bav";
    };
  };
  "jsunit-1.6" = mkJenkinsPlugin {
    name = "jsunit-1.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jsunit/1.6/jsunit.hpi";
      sha256 = "1lzf95acqfl0bdyqkvlr0jsb1bfqigm9wcr8xcng3bf95qz3qjn9";
    };
  };
  "jswidgets-1.10" = mkJenkinsPlugin {
    name = "jswidgets-1.10";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jswidgets/1.10/jswidgets.hpi";
      sha256 = "0ia6f0jxqx7wb3dc5jyay7fnaxiyjg3ay3wx9spg1bvidfg7kzcb";
    };
  };
  "junit-attachments-1.3" = mkJenkinsPlugin {
    name = "junit-attachments-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/junit-attachments/1.3/junit-attachments.hpi";
      sha256 = "09zllwd9dhwljjxj5cpp7nv89hr48ihil530zjp6l0a9h05rm5js";
    };
  };
  "junit-realtime-test-reporter-0.2" = mkJenkinsPlugin {
    name = "junit-realtime-test-reporter-0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/junit-realtime-test-reporter/0.2/junit-realtime-test-reporter.hpi";
      sha256 = "02myzjxmc9yg2hpdnd6snfvs1bhdaanwdyzx0zr8cqfd5l43bgag";
    };
  };
  "junit-1.10" = mkJenkinsPlugin {
    name = "junit-1.10";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/junit/1.10/junit.hpi";
      sha256 = "1wrvcjpvf4y39gqah80n5pz9246np051mqn7wcsk1k4a78i5bqv2";
    };
  };
  "jython-1.9" = mkJenkinsPlugin {
    name = "jython-1.9";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/jython/1.9/jython.hpi";
      sha256 = "0678729p9q22mnia1smi0ljnpjix3n7c79lypkx97i31p5zrkn0i";
    };
  };
  "kagemai-1.3" = mkJenkinsPlugin {
    name = "kagemai-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/kagemai/1.3/kagemai.hpi";
      sha256 = "1n69vvd6silyk02kf3qinhiw2yd7vg2agwz7bmgpmcvr600c9xw1";
    };
  };
  "keepSlaveOffline-1.0" = mkJenkinsPlugin {
    name = "keepSlaveOffline-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/keepSlaveOffline/1.0/keepSlaveOffline.hpi";
      sha256 = "1yakw81la8ribm63z1x6fjgpzgbgfdchbsl8vg9diwj1aqynklbz";
    };
  };
  "kerberos-sso-1.0.2" = mkJenkinsPlugin {
    name = "kerberos-sso-1.0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/kerberos-sso/1.0.2/kerberos-sso.hpi";
      sha256 = "1lmyyccrfi03hg2x95fjapjmpl21q6q5xl88w4cz5ganb1nz3cky";
    };
  };
  "keyboard-shortcuts-plugin-1.2" = mkJenkinsPlugin {
    name = "keyboard-shortcuts-plugin-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/keyboard-shortcuts-plugin/1.2/keyboard-shortcuts-plugin.hpi";
      sha256 = "0g0abnd6rq7xp7lpsvzwnxic43yk00s5vwhb1psl7n6idqbvamaa";
    };
  };
  "kiuwanJenkinsPlugin-1.3.5" = mkJenkinsPlugin {
    name = "kiuwanJenkinsPlugin-1.3.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/kiuwanJenkinsPlugin/1.3.5/kiuwanJenkinsPlugin.hpi";
      sha256 = "0jh3dxj5hmd2nczcpk77p8ns0a4pa1kh6ficbn7mg68rn9ik5rc5";
    };
  };
  "klaros-testmanagement-1.5.1" = mkJenkinsPlugin {
    name = "klaros-testmanagement-1.5.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/klaros-testmanagement/1.5.1/klaros-testmanagement.hpi";
      sha256 = "00w4y5mjsdhfmh5m7nx5ybnlrpckmdbkh809xcmivfpkcq4gzb39";
    };
  };
  "klocwork-1.18" = mkJenkinsPlugin {
    name = "klocwork-1.18";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/klocwork/1.18/klocwork.hpi";
      sha256 = "00ajn43qc4lrhhzvflhcmy2m861rzlw79y8qlhdshbxfkv5gvfmg";
    };
  };
  "kmap-jenkins-1.6" = mkJenkinsPlugin {
    name = "kmap-jenkins-1.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/kmap-jenkins/1.6/kmap-jenkins.hpi";
      sha256 = "0fbqpkr5rb0im3wvwph4z3v9cy9527p7s0psmwpp45ak20zcwq67";
    };
  };
  "koji-0.3" = mkJenkinsPlugin {
    name = "koji-0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/koji/0.3/koji.hpi";
      sha256 = "0dplqnjw0rxdr0ikpgy6i702sb78p195vg7w8ic1ix7qp2fhqyp3";
    };
  };
  "kpp-management-plugin-1.0.0" = mkJenkinsPlugin {
    name = "kpp-management-plugin-1.0.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/kpp-management-plugin/1.0.0/kpp-management-plugin.hpi";
      sha256 = "0nixv4bvikgs9a5jhxqhdkprjayfx6vymj3i327hbcfmnj44rnhc";
    };
  };
  "kubernetes-0.5" = mkJenkinsPlugin {
    name = "kubernetes-0.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/kubernetes/0.5/kubernetes.hpi";
      sha256 = "1aidyqs5g69y82n9nq0jx1fkrxncmck1xdyp1mxzwb4iwi4hx9hk";
    };
  };
  "label-linked-jobs-4.0.3" = mkJenkinsPlugin {
    name = "label-linked-jobs-4.0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/label-linked-jobs/4.0.3/label-linked-jobs.hpi";
      sha256 = "0pl294ljzkc9isixlsjd6rhp93s32zlhcx2mfh0pcsnvlj0n1szq";
    };
  };
  "label-verifier-1.1" = mkJenkinsPlugin {
    name = "label-verifier-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/label-verifier/1.1/label-verifier.hpi";
      sha256 = "1yfa5kypcj13dv0lv3j7gv00zmrf2dsvdf417r1qg5lc1zwm1a4h";
    };
  };
  "labeled-test-groups-publisher-1.2.8" = mkJenkinsPlugin {
    name = "labeled-test-groups-publisher-1.2.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/labeled-test-groups-publisher/1.2.8/labeled-test-groups-publisher.hpi";
      sha256 = "05bwfyl15xiamiyhqkpnfz8dq92v9ly0npwvr61cwxjrjxcd8id7";
    };
  };
  "labmanager-0.2.8" = mkJenkinsPlugin {
    name = "labmanager-0.2.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/labmanager/0.2.8/labmanager.hpi";
      sha256 = "08rj7wvwynwzqq8cc13cl67afpkagaap3hbi8mi1bmidlyapb6z2";
    };
  };
  "lastfailureversioncolumn-1.1" = mkJenkinsPlugin {
    name = "lastfailureversioncolumn-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/lastfailureversioncolumn/1.1/lastfailureversioncolumn.hpi";
      sha256 = "1big3hf7v2flkmk6lb2400l4z1qva8vxr1ifqysl1h11wpw0ywj1";
    };
  };
  "lastsuccessdescriptioncolumn-1.0" = mkJenkinsPlugin {
    name = "lastsuccessdescriptioncolumn-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/lastsuccessdescriptioncolumn/1.0/lastsuccessdescriptioncolumn.hpi";
      sha256 = "1i0jfr40kw55f9d1ny2hmchs880cgf39l5jg046a9p41ghzrfkaa";
    };
  };
  "lastsuccessversioncolumn-1.1" = mkJenkinsPlugin {
    name = "lastsuccessversioncolumn-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/lastsuccessversioncolumn/1.1/lastsuccessversioncolumn.hpi";
      sha256 = "1rbrkvrf1sl96fhcjdji2pag31vvnb93fmk29vplx62cfq150bms";
    };
  };
  "ldap-1.11" = mkJenkinsPlugin {
    name = "ldap-1.11";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ldap/1.11/ldap.hpi";
      sha256 = "1qpx22n7g4bmpk3gg03i5bvz13m57lm5d17xrmawqd5h1jyy2zwa";
    };
  };
  "ldapemail-0.8" = mkJenkinsPlugin {
    name = "ldapemail-0.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ldapemail/0.8/ldapemail.hpi";
      sha256 = "1jij13nljnr29h4j9s1ik96mls317i10g0gnh6jbzsfw3nvb416j";
    };
  };
  "leastload-1.0.3" = mkJenkinsPlugin {
    name = "leastload-1.0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/leastload/1.0.3/leastload.hpi";
      sha256 = "056z1374vghrghcji1sg2ar47nv1c7klsrdwrvz4kf6dkrpgl3mz";
    };
  };
  "leiningen-plugin-0.5.6" = mkJenkinsPlugin {
    name = "leiningen-plugin-0.5.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/leiningen-plugin/0.5.6/leiningen-plugin.hpi";
      sha256 = "14b4ahbc5n1y5j16k5hr36kyqkls2admcczjvmz16kb8d69i9wka";
    };
  };
  "lenientshutdown-1.0.0" = mkJenkinsPlugin {
    name = "lenientshutdown-1.0.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/lenientshutdown/1.0.0/lenientshutdown.hpi";
      sha256 = "08wh0h64wsh9qz05xqa4ld29q7x9iqiww7mbfpdpg0swfnj9f564";
    };
  };
  "libvirt-slave-1.8.5" = mkJenkinsPlugin {
    name = "libvirt-slave-1.8.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/libvirt-slave/1.8.5/libvirt-slave.hpi";
      sha256 = "0hzihkzpdw43srvj760f25ixywr5hvdzb30cyb7p91p4klkh7n0c";
    };
  };
  "lifx-notifier-0.2" = mkJenkinsPlugin {
    name = "lifx-notifier-0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/lifx-notifier/0.2/lifx-notifier.hpi";
      sha256 = "01my5cg9pmiba9hjmrylc3ky5q8rrhcqq9f9hharac7yj5lfhy84";
    };
  };
  "linenumbers-1.1" = mkJenkinsPlugin {
    name = "linenumbers-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/linenumbers/1.1/linenumbers.hpi";
      sha256 = "1f30p529d18z1d7n6qa0hprsg5bfj6fj0hbaril9qf2ypfx6sbda";
    };
  };
  "lingr-plugin-0.1" = mkJenkinsPlugin {
    name = "lingr-plugin-0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/lingr-plugin/0.1/lingr-plugin.hpi";
      sha256 = "1dhdxrqcsd22r4h7zzil2vbjj8k9zvcwmwp8wbf8p3550fg26nl3";
    };
  };
  "list-command-0.2" = mkJenkinsPlugin {
    name = "list-command-0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/list-command/0.2/list-command.hpi";
      sha256 = "07f6dai1q15j3n7k4mjg883x5wmxj07lycynr8wgn3km2nrh4nps";
    };
  };
  "literate-1.0" = mkJenkinsPlugin {
    name = "literate-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/literate/1.0/literate.hpi";
      sha256 = "1rjik51348c6hpbmjv4xh2ksinwfbjj8vvd6zamkyb8fzhcgvdnd";
    };
  };
  "liverebel-deploy-2.7.4" = mkJenkinsPlugin {
    name = "liverebel-deploy-2.7.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/liverebel-deploy/2.7.4/liverebel-deploy.hpi";
      sha256 = "0qn34akpbl83l8cchhx4yvl5r25balrf6x0wxj8frs53ns7nfjix";
    };
  };
  "livescreenshot-1.4.5" = mkJenkinsPlugin {
    name = "livescreenshot-1.4.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/livescreenshot/1.4.5/livescreenshot.hpi";
      sha256 = "1qvy42kn3q6aqmfqpy5l62y9bw013v3aa0i7dvph7k2df8fph6rz";
    };
  };
  "loaderio-jenkins-plugin-1.0.1" = mkJenkinsPlugin {
    name = "loaderio-jenkins-plugin-1.0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/loaderio-jenkins-plugin/1.0.1/loaderio-jenkins-plugin.hpi";
      sha256 = "1b6553yf84375y4cb8ifvr8dvkc1ns29s1ni591ha2bikflvql3c";
    };
  };
  "loadimpact-plugin-1.62" = mkJenkinsPlugin {
    name = "loadimpact-plugin-1.62";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/loadimpact-plugin/1.62/loadimpact-plugin.hpi";
      sha256 = "1d833dd6x24xvnfmqbi3cy1bgzbgkxs0y5fr2d7ay66gg2s2dja1";
    };
  };
  "locale-1.2" = mkJenkinsPlugin {
    name = "locale-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/locale/1.2/locale.hpi";
      sha256 = "0p6sh1a4j5xc1lk7armsab4vkw7nqw96y2c131knpd9j2dr56xmv";
    };
  };
  "lockable-resources-1.7" = mkJenkinsPlugin {
    name = "lockable-resources-1.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/lockable-resources/1.7/lockable-resources.hpi";
      sha256 = "12jsp0lih21a9kwmrq6035nds7dr9xb1pb7imh8wg2g8h3c63rlv";
    };
  };
  "locked-files-report-1.6" = mkJenkinsPlugin {
    name = "locked-files-report-1.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/locked-files-report/1.6/locked-files-report.hpi";
      sha256 = "13clsp6r1ydkl16njldv2f6q04l7qlbyr25g69pj7l1mlmw77sg5";
    };
  };
  "locks-and-latches-0.6" = mkJenkinsPlugin {
    name = "locks-and-latches-0.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/locks-and-latches/0.6/locks-and-latches.hpi";
      sha256 = "1hvys0wm8x21jxm1cchsf7i91ynpn3m06x85fpba1390bxngyiv8";
    };
  };
  "log-command-1.0.1" = mkJenkinsPlugin {
    name = "log-command-1.0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/log-command/1.0.1/log-command.hpi";
      sha256 = "11z633bhzlgw3czh5k5im7bgbfn31rvf9i42xaaqv6bc8w9hwhdz";
    };
  };
  "log-parser-2.0" = mkJenkinsPlugin {
    name = "log-parser-2.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/log-parser/2.0/log-parser.hpi";
      sha256 = "0qhi5sgy7za7yli8gph4iqgv3mnikrbd916ql7m89vws25hc93hy";
    };
  };
  "logaction-plugin-1.2" = mkJenkinsPlugin {
    name = "logaction-plugin-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/logaction-plugin/1.2/logaction-plugin.hpi";
      sha256 = "05iblbl4h0bgirsh2zwipy2251kndidqz9aay2jxsdimfxgyvnj7";
    };
  };
  "logentries-0.0.2" = mkJenkinsPlugin {
    name = "logentries-0.0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/logentries/0.0.2/logentries.hpi";
      sha256 = "04109in1p502n0gscvras7y8k7j5i7andi4alldhqr3s7d17c9hf";
    };
  };
  "logfilesizechecker-1.2" = mkJenkinsPlugin {
    name = "logfilesizechecker-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/logfilesizechecker/1.2/logfilesizechecker.hpi";
      sha256 = "1vicgba271m34qy7m6axp53qhjs3jvmdqm6nj5vns0py7h2p42ss";
    };
  };
  "logging-1.0.0" = mkJenkinsPlugin {
    name = "logging-1.0.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/logging/1.0.0/logging.hpi";
      sha256 = "12b1d8kq5h5l2x1xr2vlf5sl28bqp719bksvja13kmspz4zr1x6s";
    };
  };
  "logstash-1.1.1" = mkJenkinsPlugin {
    name = "logstash-1.1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/logstash/1.1.1/logstash.hpi";
      sha256 = "17fbhz6bmsjg4s7bngpwj6g2ly0w8ilf0s324jc9rfs87f3nsrv9";
    };
  };
  "lotus-connections-plugin-1.25" = mkJenkinsPlugin {
    name = "lotus-connections-plugin-1.25";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/lotus-connections-plugin/1.25/lotus-connections-plugin.hpi";
      sha256 = "1am6inbarlqnynx22jwqc8yzx28q00fgqkhsi23l3n5x1dqca5lk";
    };
  };
  "lsf-cloud-1.11" = mkJenkinsPlugin {
    name = "lsf-cloud-1.11";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/lsf-cloud/1.11/lsf-cloud.hpi";
      sha256 = "0war2rckhicsm9cl78a3rr4y5bwmnli1dclsf047j7bcvzxiidlx";
    };
  };
  "lucene-search-4.2" = mkJenkinsPlugin {
    name = "lucene-search-4.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/lucene-search/4.2/lucene-search.hpi";
      sha256 = "00j6biglrywj70lkpv4ndgq9k3bym7r2wdnyd5l0c8kz19qxrv76";
    };
  };
  "m2-repo-reaper-1.0" = mkJenkinsPlugin {
    name = "m2-repo-reaper-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/m2-repo-reaper/1.0/m2-repo-reaper.hpi";
      sha256 = "174gwk5gp6dw3yrwqnlxbg5h8gdhyfayfxfzbx32dqjw66h022pj";
    };
  };
  "m2release-0.14.0" = mkJenkinsPlugin {
    name = "m2release-0.14.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/m2release/0.14.0/m2release.hpi";
      sha256 = "0ngj1wx1sfl7l4d9x5nff8ilc3y9pykhmbsn027d6vr67rl3gqwx";
    };
  };
  "mail-watcher-plugin-1.13" = mkJenkinsPlugin {
    name = "mail-watcher-plugin-1.13";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/mail-watcher-plugin/1.13/mail-watcher-plugin.hpi";
      sha256 = "1brggkr2v91hn0fh8aia82kdsqnnca3v29pfcghg8x2mdmrmvrgv";
    };
  };
  "mailcommander-1.0.0" = mkJenkinsPlugin {
    name = "mailcommander-1.0.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/mailcommander/1.0.0/mailcommander.hpi";
      sha256 = "01ynn3rc2x31rxdvyvyfzw01pnfhd276f2bn29pd5xbszq2bzbs0";
    };
  };
  "mailer-1.16" = mkJenkinsPlugin {
    name = "mailer-1.16";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/mailer/1.16/mailer.hpi";
      sha256 = "19dbcaax5gwf1wqa7p8gd9c1yl5ppkflfqly30krhysmxczx87gl";
    };
  };
  "mailmap-resolver-0.2" = mkJenkinsPlugin {
    name = "mailmap-resolver-0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/mailmap-resolver/0.2/mailmap-resolver.hpi";
      sha256 = "10w7zyn17dph9s8kdyklk0mir162s8xdbvmrcm418a9qyzj1ipas";
    };
  };
  "maintenance-jobs-scheduler-0.1.0" = mkJenkinsPlugin {
    name = "maintenance-jobs-scheduler-0.1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/maintenance-jobs-scheduler/0.1.0/maintenance-jobs-scheduler.hpi";
      sha256 = "1xzffllbbh0wk7z0ccxnv7q28jpawlwi43k8715szx6fzdix6x2h";
    };
  };
  "managed-scripts-1.2.1" = mkJenkinsPlugin {
    name = "managed-scripts-1.2.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/managed-scripts/1.2.1/managed-scripts.hpi";
      sha256 = "1nhcmdpvsdy5mbbs9naxbzhk2zksvalq6rkwklh5azw7f8hpid9y";
    };
  };
  "mansion-cloud-1.30" = mkJenkinsPlugin {
    name = "mansion-cloud-1.30";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/mansion-cloud/1.30/mansion-cloud.hpi";
      sha256 = "0sxdfv32r392fqm21ckcmn1p6v1svaxy7y9yzni6ab3r22jsa0gi";
    };
  };
  "mantis-0.26" = mkJenkinsPlugin {
    name = "mantis-0.26";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/mantis/0.26/mantis.hpi";
      sha256 = "049qwsmqc621jfj01z0vadrxxiffbjf8yf4xchvd17f7dd0spfda";
    };
  };
  "mapdb-api-1.0.6.0" = mkJenkinsPlugin {
    name = "mapdb-api-1.0.6.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/mapdb-api/1.0.6.0/mapdb-api.hpi";
      sha256 = "1j2i353703zl7bff7s6y7d0658jpx280v53rry4clkr4i9340m55";
    };
  };
  "mashup-portlets-plugin-1.0.6" = mkJenkinsPlugin {
    name = "mashup-portlets-plugin-1.0.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/mashup-portlets-plugin/1.0.6/mashup-portlets-plugin.hpi";
      sha256 = "1jgdcwj08k3gj9mgldy9jc5hr7qv6v54binpdfs3056m64g5xbjs";
    };
  };
  "mask-passwords-2.8" = mkJenkinsPlugin {
    name = "mask-passwords-2.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/mask-passwords/2.8/mask-passwords.hpi";
      sha256 = "109gykarqi6iraw7i0a89svrp35xfx903ndhf4v93yhl6gn3sxj3";
    };
  };
  "matrix-auth-1.2" = mkJenkinsPlugin {
    name = "matrix-auth-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/matrix-auth/1.2/matrix-auth.hpi";
      sha256 = "16pkmr87g692g4hjm9vgbgq9fv9jj2130rh43kzv4w1ddgyw4wx7";
    };
  };
  "matrix-combinations-parameter-1.0.9" = mkJenkinsPlugin {
    name = "matrix-combinations-parameter-1.0.9";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/matrix-combinations-parameter/1.0.9/matrix-combinations-parameter.hpi";
      sha256 = "00zpp0a4mq9aipr3prsfnhycn3gk896cjnk629pybrm0i4irv81h";
    };
  };
  "matrix-groovy-execution-strategy-1.0.4" = mkJenkinsPlugin {
    name = "matrix-groovy-execution-strategy-1.0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/matrix-groovy-execution-strategy/1.0.4/matrix-groovy-execution-strategy.hpi";
      sha256 = "0sm6m0vlj0d7a6bkdw37mmy9657gih8xh47rk621qpzcb5lh9xws";
    };
  };
  "matrix-project-1.6" = mkJenkinsPlugin {
    name = "matrix-project-1.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/matrix-project/1.6/matrix-project.hpi";
      sha256 = "1pbp50vps7ir631rzhw83zxkw40s5hdncjclckkpy6bzh32x2vrw";
    };
  };
  "matrix-reloaded-1.1.3" = mkJenkinsPlugin {
    name = "matrix-reloaded-1.1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/matrix-reloaded/1.1.3/matrix-reloaded.hpi";
      sha256 = "0mmxkq7z213dgj2fbi0z44p2smv9aihc02m08ii445hkpmcxlylz";
    };
  };
  "matrixtieparent-1.2" = mkJenkinsPlugin {
    name = "matrixtieparent-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/matrixtieparent/1.2/matrixtieparent.hpi";
      sha256 = "0aggk16pyybdj1fy4d89xa9b2bns9y2ipfqdjjgik7zip1hmvbm3";
    };
  };
  "mattermost-1.5.0" = mkJenkinsPlugin {
    name = "mattermost-1.5.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/mattermost/1.5.0/mattermost.hpi";
      sha256 = "118k2x646mv8biyjl9jqj9ciwbqab8pzww60icm64ychvmqlih23";
    };
  };
  "maven-dependency-update-trigger-1.5" = mkJenkinsPlugin {
    name = "maven-dependency-update-trigger-1.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/maven-dependency-update-trigger/1.5/maven-dependency-update-trigger.hpi";
      sha256 = "0fim20xsr64b6875b920dpaqfx4gww1hqr7pwhhf1zvbmvczh5vq";
    };
  };
  "maven-deployment-linker-1.5.1" = mkJenkinsPlugin {
    name = "maven-deployment-linker-1.5.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/maven-deployment-linker/1.5.1/maven-deployment-linker.hpi";
      sha256 = "1dhkj4yibvxx8b6klw9zhfzwp8hsj2f138sdk7ikw20m2bixmkqf";
    };
  };
  "maven-info-0.2.0" = mkJenkinsPlugin {
    name = "maven-info-0.2.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/maven-info/0.2.0/maven-info.hpi";
      sha256 = "12iaqwlh4vj1vwy1adagb832h4a5v72dp13qfm86q6p8pk86ammi";
    };
  };
  "maven-invoker-plugin-1.2" = mkJenkinsPlugin {
    name = "maven-invoker-plugin-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/maven-invoker-plugin/1.2/maven-invoker-plugin.hpi";
      sha256 = "0axpavx90bwl2r1p9f8chqyz1w2cl3h4ddjhwb63vcm3w8vka91m";
    };
  };
  "maven-metadata-plugin-1.3.0" = mkJenkinsPlugin {
    name = "maven-metadata-plugin-1.3.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/maven-metadata-plugin/1.3.0/maven-metadata-plugin.hpi";
      sha256 = "0xijmynfhzjdsnsd58a7rvhpmxzg123rnyzlmlb79vqk9bxmqzny";
    };
  };
  "maven-plugin-2.12.1" = mkJenkinsPlugin {
    name = "maven-plugin-2.12.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/maven-plugin/2.12.1/maven-plugin.hpi";
      sha256 = "0zb5p5nxzdm2dv2f4gsvmjmpxzjb6saln9q14g4v42q4j4bfrahr";
    };
  };
  "maven-release-cascade-1.3.2" = mkJenkinsPlugin {
    name = "maven-release-cascade-1.3.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/maven-release-cascade/1.3.2/maven-release-cascade.hpi";
      sha256 = "1rxrzz8fwvkfmr9im4jj521gil4ss6kv5sbv0w4ay0n4w8hn0fc4";
    };
  };
  "maven-repo-cleaner-1.2" = mkJenkinsPlugin {
    name = "maven-repo-cleaner-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/maven-repo-cleaner/1.2/maven-repo-cleaner.hpi";
      sha256 = "17c7yg9fnmflr0kpmkwsdwk8s0j74njbb0z266gxysiazn6iq2m8";
    };
  };
  "mber-1.5.0" = mkJenkinsPlugin {
    name = "mber-1.5.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/mber/1.5.0/mber.hpi";
      sha256 = "1zgpsizgjsy33ma0izmhngx5zvz3nggbsxy0fi6grm1p98sx14zy";
    };
  };
  "mdtool-0.1.1" = mkJenkinsPlugin {
    name = "mdtool-0.1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/mdtool/0.1.1/mdtool.hpi";
      sha256 = "06639jy1hm19ai5ly2ym1yha3awgwjx7qg90kgs920xyndq0f7hw";
    };
  };
  "measurement-plots-0.1" = mkJenkinsPlugin {
    name = "measurement-plots-0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/measurement-plots/0.1/measurement-plots.hpi";
      sha256 = "1c6x23ms9ivl0qkqvl9jja76krpjv3ncd7fdpycxbxh6s5ij6wy8";
    };
  };
  "meliora-testlab-1.7" = mkJenkinsPlugin {
    name = "meliora-testlab-1.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/meliora-testlab/1.7/meliora-testlab.hpi";
      sha256 = "1z1rrbzd0201xdbpqdr2j86lqa8s0s72wkx21x13sk4zvzslvxd0";
    };
  };
  "memegen-0.5.1" = mkJenkinsPlugin {
    name = "memegen-0.5.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/memegen/0.5.1/memegen.hpi";
      sha256 = "173rzgg9h4imv2ipnlymk5xagc0nj7151ylwma94kp2n3p055ddf";
    };
  };
  "memory-map-2.1.2" = mkJenkinsPlugin {
    name = "memory-map-2.1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/memory-map/2.1.2/memory-map.hpi";
      sha256 = "1idjp5450l27l9kagk2cq84k63s5mxjbmvbz7sanibn1kq6h0p2d";
    };
  };
  "mercurial-1.54" = mkJenkinsPlugin {
    name = "mercurial-1.54";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/mercurial/1.54/mercurial.hpi";
      sha256 = "13r5lvayqsz0f1mn9dfw3ys3xs3flmysfgms8jgacidh9jp1grh6";
    };
  };
  "mesos-0.9.0" = mkJenkinsPlugin {
    name = "mesos-0.9.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/mesos/0.9.0/mesos.hpi";
      sha256 = "1fv3m8nwz5bflipjj6d07vb4nwgb5nzhsgf1ccm3kfvnxdf6xdln";
    };
  };
  "metadata-1.1.0b" = mkJenkinsPlugin {
    name = "metadata-1.1.0b";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/metadata/1.1.0b/metadata.hpi";
      sha256 = "13hqx83hm9jng7ny1nddqs17ipnr0zxdim9vgfcbdjr33p7fkczg";
    };
  };
  "metrics-diskusage-3.0.0" = mkJenkinsPlugin {
    name = "metrics-diskusage-3.0.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/metrics-diskusage/3.0.0/metrics-diskusage.hpi";
      sha256 = "0f8l97bkqczv74zca1sy8gg80168vm31n9b5rvhg0j2rnmzdvq55";
    };
  };
  "metrics-ganglia-3.0.0" = mkJenkinsPlugin {
    name = "metrics-ganglia-3.0.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/metrics-ganglia/3.0.0/metrics-ganglia.hpi";
      sha256 = "1684ksqqdykvyjp5d3zwdi72dj859kv9vcmbic784b25mhx2fzlg";
    };
  };
  "metrics-graphite-3.0.0" = mkJenkinsPlugin {
    name = "metrics-graphite-3.0.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/metrics-graphite/3.0.0/metrics-graphite.hpi";
      sha256 = "0w2c156fzr7bq29mspimxkckf4rlkzcfg7yncgm2jadqddpsi2mi";
    };
  };
  "metrics-3.1.2.2" = mkJenkinsPlugin {
    name = "metrics-3.1.2.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/metrics/3.1.2.2/metrics.hpi";
      sha256 = "11yx7qppkykyj0qyhxhxpd7gawai0f9c6z9ny0iqnggm4z0zw16x";
    };
  };
  "mission-control-view-0.8.3" = mkJenkinsPlugin {
    name = "mission-control-view-0.8.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/mission-control-view/0.8.3/mission-control-view.hpi";
      sha256 = "1j8z2fa1yflddkkklhnpy3jfisich34psn9mar7j7sv4d2cg348w";
    };
  };
  "mktmpio-0.3.2" = mkJenkinsPlugin {
    name = "mktmpio-0.3.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/mktmpio/0.3.2/mktmpio.hpi";
      sha256 = "0yk7lbg91lphnsx7wdb53g9p2abh5v684a8q45acljr9a80lz0zk";
    };
  };
  "mock-load-builder-1.0" = mkJenkinsPlugin {
    name = "mock-load-builder-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/mock-load-builder/1.0/mock-load-builder.hpi";
      sha256 = "13l6bvyfsjxg092hrh0bxgnalgibgjam4hpfxdzirfqn1fmq6snn";
    };
  };
  "mock-security-realm-1.3" = mkJenkinsPlugin {
    name = "mock-security-realm-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/mock-security-realm/1.3/mock-security-realm.hpi";
      sha256 = "177pj6phwjby7cw3h8nr099r8bra363wsh3bxn9hpgx15b7gl5a9";
    };
  };
  "mock-slave-1.8" = mkJenkinsPlugin {
    name = "mock-slave-1.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/mock-slave/1.8/mock-slave.hpi";
      sha256 = "17dwh8qni8hr116zrijbwybg2cpyy5amnl7n4h645h8jcy55jh2h";
    };
  };
  "modernstatus-1.2" = mkJenkinsPlugin {
    name = "modernstatus-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/modernstatus/1.2/modernstatus.hpi";
      sha256 = "0m5crx0xbi5dxglyb3xfn5xgflgfj1qfzqvn9djmzaz7819igzqc";
    };
  };
  "momentjs-1.1" = mkJenkinsPlugin {
    name = "momentjs-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/momentjs/1.1/momentjs.hpi";
      sha256 = "0cr3l8bg5xh99kxryvp68jvd0dhdv35mbgpra9ykihm9vrzhkz42";
    };
  };
  "mongodb-document-upload-1.0" = mkJenkinsPlugin {
    name = "mongodb-document-upload-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/mongodb-document-upload/1.0/mongodb-document-upload.hpi";
      sha256 = "1aldv7q9qyxs5j569wsr65wqsssn094449i7ni5jjrn4d9qha4an";
    };
  };
  "mongodb-1.3" = mkJenkinsPlugin {
    name = "mongodb-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/mongodb/1.3/mongodb.hpi";
      sha256 = "1i3wp9dbsgdz2f093c5vhbjl7zv63q4qr3lpiklrcw5y8k9552as";
    };
  };
  "monitoring-1.58.0" = mkJenkinsPlugin {
    name = "monitoring-1.58.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/monitoring/1.58.0/monitoring.hpi";
      sha256 = "10y9brzd2g4dy6lkar147afgcfcri42ks01sld36gs3kvibaqfb2";
    };
  };
  "monkit-plugin-1.0.0" = mkJenkinsPlugin {
    name = "monkit-plugin-1.0.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/monkit-plugin/1.0.0/monkit-plugin.hpi";
      sha256 = "01sgfnsp5ivpbh1a1zdpn4h0nxh8csp7n6n72s9bjnwvjf6rhxjr";
    };
  };
  "mozmill-1.3" = mkJenkinsPlugin {
    name = "mozmill-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/mozmill/1.3/mozmill.hpi";
      sha256 = "05csj8h0rpvfgkk730d7g6p7s5nrmx969jbmialyln8dp98llapc";
    };
  };
  "mqtt-notification-plugin-1.3" = mkJenkinsPlugin {
    name = "mqtt-notification-plugin-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/mqtt-notification-plugin/1.3/mqtt-notification-plugin.hpi";
      sha256 = "1c7pg7z78l7hsx1zhns5x523yfnx4b8lx6gc6mm385kc3my1innk";
    };
  };
  "msbuild-1.25" = mkJenkinsPlugin {
    name = "msbuild-1.25";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/msbuild/1.25/msbuild.hpi";
      sha256 = "0pkny1qx84fg7r2yjnfhpkg3hsv0n2bpqb8mhg93w64ajflf4s3h";
    };
  };
  "mstest-0.19" = mkJenkinsPlugin {
    name = "mstest-0.19";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/mstest/0.19/mstest.hpi";
      sha256 = "054a6kdrhmpls4prddib8p5n2gpr76ri6brgpr7aav880r52av9x";
    };
  };
  "mstestrunner-1.2.0" = mkJenkinsPlugin {
    name = "mstestrunner-1.2.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/mstestrunner/1.2.0/mstestrunner.hpi";
      sha256 = "0x7kz01xp5rc8bb8hprh3nvh3k8vwxi0r563vxa8lycp4g16wh61";
    };
  };
  "mttr-1.1" = mkJenkinsPlugin {
    name = "mttr-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/mttr/1.1/mttr.hpi";
      sha256 = "1w96cxm9lysrl9rjqmxb8zqr2nidw8qk28q2mbjj6zhvs3hvc80k";
    };
  };
  "multi-branch-project-plugin-0.4.1" = mkJenkinsPlugin {
    name = "multi-branch-project-plugin-0.4.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/multi-branch-project-plugin/0.4.1/multi-branch-project-plugin.hpi";
      sha256 = "0x4rzcvrx325qwagv2hil3a02sdfx9rk1990f5l3d61ilnqj5f5r";
    };
  };
  "multi-module-tests-publisher-1.42" = mkJenkinsPlugin {
    name = "multi-module-tests-publisher-1.42";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/multi-module-tests-publisher/1.42/multi-module-tests-publisher.hpi";
      sha256 = "1vg33g65i0rwgh9c34amdbv147w8vcpk1bq8xdly6bz83a2sg8dg";
    };
  };
  "multi-slave-config-plugin-1.2.0" = mkJenkinsPlugin {
    name = "multi-slave-config-plugin-1.2.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/multi-slave-config-plugin/1.2.0/multi-slave-config-plugin.hpi";
      sha256 = "0fk84rdi0agb92wb0yi0dp6zir0nphzwiyckid560dq4nan8pl5l";
    };
  };
  "multiple-scms-0.5" = mkJenkinsPlugin {
    name = "multiple-scms-0.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/multiple-scms/0.5/multiple-scms.hpi";
      sha256 = "04b74inraj62r8rsdkiwc3drnz97vkr63scar56nzckhmxk4z26a";
    };
  };
  "mysql-auth-1.0" = mkJenkinsPlugin {
    name = "mysql-auth-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/mysql-auth/1.0/mysql-auth.hpi";
      sha256 = "19jxdmqvav7bhyni0k4wz3m32vdjfdqqkb7gi53miwdbzk9jhzgq";
    };
  };
  "myst-plugin-2.5.0.0" = mkJenkinsPlugin {
    name = "myst-plugin-2.5.0.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/myst-plugin/2.5.0.0/myst-plugin.hpi";
      sha256 = "1d4ffjycc12dgx1gj7yr23s083c1zsmzicvlzpdrq66g0789486f";
    };
  };
  "naginator-1.16.1" = mkJenkinsPlugin {
    name = "naginator-1.16.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/naginator/1.16.1/naginator.hpi";
      sha256 = "1bc9n13b27d18jd8c27wml1ma4r6k5g726h7yxybpq24kwgaiwyj";
    };
  };
  "nant-1.4.3" = mkJenkinsPlugin {
    name = "nant-1.4.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/nant/1.4.3/nant.hpi";
      sha256 = "116dc177064j8gp1001ysnqmdg1gw7x3b4v79d9dqmjg4dpvmy22";
    };
  };
  "ncover-0.3" = mkJenkinsPlugin {
    name = "ncover-0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ncover/0.3/ncover.hpi";
      sha256 = "15am1775d90sqx5gm46lin2243c6bpgybpgz9fjxcmvrggdfsx4y";
    };
  };
  "neoload-jenkins-plugin-1.0.1" = mkJenkinsPlugin {
    name = "neoload-jenkins-plugin-1.0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/neoload-jenkins-plugin/1.0.1/neoload-jenkins-plugin.hpi";
      sha256 = "1ljv6ckvd82xq98visdd8w3cb84b2x1kzc102ywyl0mh9d1y9znr";
    };
  };
  "nerrvana-plugin-1.02.06" = mkJenkinsPlugin {
    name = "nerrvana-plugin-1.02.06";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/nerrvana-plugin/1.02.06/nerrvana-plugin.hpi";
      sha256 = "17r9mq0i4682fkkl01ny314w02wxcv0jnl7rnd3lgx33jxcdazxs";
    };
  };
  "nested-view-1.14" = mkJenkinsPlugin {
    name = "nested-view-1.14";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/nested-view/1.14/nested-view.hpi";
      sha256 = "17za1gqfjl8zzij80w38vqxnnzrz6d613y4zph231njy4imrm0lz";
    };
  };
  "newrelic-deployment-notifier-1.3" = mkJenkinsPlugin {
    name = "newrelic-deployment-notifier-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/newrelic-deployment-notifier/1.3/newrelic-deployment-notifier.hpi";
      sha256 = "1jxwg7kxjk99nb6kf9si8b5p47jkrhai20ni2b3vvn3xhsbscfrn";
    };
  };
  "next-build-number-1.3" = mkJenkinsPlugin {
    name = "next-build-number-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/next-build-number/1.3/next-build-number.hpi";
      sha256 = "0iry29kifj0vfpjhbm46nhwi0ra1px0plwnnrb6dyql2wrvbljq7";
    };
  };
  "next-executions-1.0.10" = mkJenkinsPlugin {
    name = "next-executions-1.0.10";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/next-executions/1.0.10/next-executions.hpi";
      sha256 = "0baa5lhnydnjb1isdklbxlr9a0fk7qgvz2csyvymmlbhpib44q1x";
    };
  };
  "nexus-task-runner-0.9.2" = mkJenkinsPlugin {
    name = "nexus-task-runner-0.9.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/nexus-task-runner/0.9.2/nexus-task-runner.hpi";
      sha256 = "1ahyad0yd26fqyid3shnlwkyh5rfh77205g8g8n42qzab4hjvwm3";
    };
  };
  "nis-notification-lamp-1.131" = mkJenkinsPlugin {
    name = "nis-notification-lamp-1.131";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/nis-notification-lamp/1.131/nis-notification-lamp.hpi";
      sha256 = "1bidflyi3rga27bsh1cbqx2kls7rxb7vwqwqm1mkvx7zvz9052v2";
    };
  };
  "node-iterator-api-1.5" = mkJenkinsPlugin {
    name = "node-iterator-api-1.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/node-iterator-api/1.5/node-iterator-api.hpi";
      sha256 = "0jnkyhvh6dvhfp0km6b8z9v2kg2nwaqxqkh0lwk5mbfczja54npa";
    };
  };
  "nodejs-0.2.1" = mkJenkinsPlugin {
    name = "nodejs-0.2.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/nodejs/0.2.1/nodejs.hpi";
      sha256 = "1z73jz06ykjz4jcrl5v04kv1xqj7ydpjsdb3r4mji0dwzr2yvpnb";
    };
  };
  "nodelabelparameter-1.7.1" = mkJenkinsPlugin {
    name = "nodelabelparameter-1.7.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/nodelabelparameter/1.7.1/nodelabelparameter.hpi";
      sha256 = "0iax879m5aixqwkwkb0iba3iizfhw478qval16sgj2n11pq6j449";
    };
  };
  "nodenamecolumn-1.2" = mkJenkinsPlugin {
    name = "nodenamecolumn-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/nodenamecolumn/1.2/nodenamecolumn.hpi";
      sha256 = "1mpmrqrd6mk8hx77kj95ir5rlm53vyp6ppib1g3ja6jfi3da9m8f";
    };
  };
  "nopmdcheck-0.9" = mkJenkinsPlugin {
    name = "nopmdcheck-0.9";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/nopmdcheck/0.9/nopmdcheck.hpi";
      sha256 = "17n9c6li3za4jwqz6xhmjigvxb82vanz3m09v3whgvcjwbg0h1fb";
    };
  };
  "nopmdverifytrac-0.9" = mkJenkinsPlugin {
    name = "nopmdverifytrac-0.9";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/nopmdverifytrac/0.9/nopmdverifytrac.hpi";
      sha256 = "0gn4mcm2a4mrwwihwlmx702nq4aihr6iqky30w8fzqlvlmrhc28j";
    };
  };
  "notification-1.10" = mkJenkinsPlugin {
    name = "notification-1.10";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/notification/1.10/notification.hpi";
      sha256 = "0mpmrh860z35bl7vbyjyab39j1q4lh2b6ilssm2azf28hnz2bcj7";
    };
  };
  "nouvola-divecloud-1.02" = mkJenkinsPlugin {
    name = "nouvola-divecloud-1.02";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/nouvola-divecloud/1.02/nouvola-divecloud.hpi";
      sha256 = "1q9a278c4zqqmmzhw3z9a90hhihpwm2kzy0xmr6cn3pdmlpgdnp6";
    };
  };
  "nsiqcollector-1.3.3" = mkJenkinsPlugin {
    name = "nsiqcollector-1.3.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/nsiqcollector/1.3.3/nsiqcollector.hpi";
      sha256 = "0d25xf0nbvmnyl35f0ynh9ndy3zamj63wdlaxwvd8n59ryv2mx08";
    };
  };
  "nuget-0.4" = mkJenkinsPlugin {
    name = "nuget-0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/nuget/0.4/nuget.hpi";
      sha256 = "1azpdwk75z3100wd95g978g1mhbs496ifcr1i09cf3hansg023ip";
    };
  };
  "numeraljs-1.1" = mkJenkinsPlugin {
    name = "numeraljs-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/numeraljs/1.1/numeraljs.hpi";
      sha256 = "0llsh989fxcbbjmp185agln5a4l44z2glp1sj2avs3wc8ylshz41";
    };
  };
  "nunit-0.17" = mkJenkinsPlugin {
    name = "nunit-0.17";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/nunit/0.17/nunit.hpi";
      sha256 = "1nqv7k049zayydmnr2xj6q7rr89z7j8h2ig2s83kdbm932nv8pdj";
    };
  };
  "oauth-credentials-0.3" = mkJenkinsPlugin {
    name = "oauth-credentials-0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/oauth-credentials/0.3/oauth-credentials.hpi";
      sha256 = "1aljcpaa6cvcc0hv6v9rq0jypas64ja4qndcpiqjnzb6m15msgbw";
    };
  };
  "octopusdeploy-1.3.1" = mkJenkinsPlugin {
    name = "octopusdeploy-1.3.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/octopusdeploy/1.3.1/octopusdeploy.hpi";
      sha256 = "0hkka4rks16kdc58yyd2r6siha14gx6dn16rgc2dph8ar8xw4ghn";
    };
  };
  "offlineonfailure-plugin-1.0" = mkJenkinsPlugin {
    name = "offlineonfailure-plugin-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/offlineonfailure-plugin/1.0/offlineonfailure-plugin.hpi";
      sha256 = "1kml9aah3b7cpz1rgm76zn71r62gg03fnwrkncskxc60na6f2rn6";
    };
  };
  "ontrack-2.17.0" = mkJenkinsPlugin {
    name = "ontrack-2.17.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ontrack/2.17.0/ontrack.hpi";
      sha256 = "00xw22cgg0dip9cjncac6088kq3k607i5w4fmh5918win2c031br";
    };
  };
  "openJDK-native-plugin-1.1" = mkJenkinsPlugin {
    name = "openJDK-native-plugin-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/openJDK-native-plugin/1.1/openJDK-native-plugin.hpi";
      sha256 = "1bhxks7p4qs0ygxfx6nrxa4w2zx322hna1bmj53p7ksl9vgp8hy0";
    };
  };
  "openid-2.1.1" = mkJenkinsPlugin {
    name = "openid-2.1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/openid/2.1.1/openid.hpi";
      sha256 = "066whv691ds605l81kzsy5l38yfia3dhxjd24wgwfg9cvjbldv9b";
    };
  };
  "openid4java-0.9.8.0" = mkJenkinsPlugin {
    name = "openid4java-0.9.8.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/openid4java/0.9.8.0/openid4java.hpi";
      sha256 = "0b97y4xprpgd7wyl3dw0j3mfd6kw214lx2k2l0cfqbrpp43kyh8i";
    };
  };
  "openscada-jenkins-exporter-0.0.2" = mkJenkinsPlugin {
    name = "openscada-jenkins-exporter-0.0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/openscada-jenkins-exporter/0.0.2/openscada-jenkins-exporter.hpi";
      sha256 = "1yzl6dj6sv9z0xd0iis4s24ysixd92ii2svfnnbkqs318hw8ag9m";
    };
  };
  "openshift-deployer-1.2.0" = mkJenkinsPlugin {
    name = "openshift-deployer-1.2.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/openshift-deployer/1.2.0/openshift-deployer.hpi";
      sha256 = "1f2avwbbd6rll0n65mwajbh68675nl9cn8zw15280yfbzxdkh37q";
    };
  };
  "openshift-pipeline-1.0.7" = mkJenkinsPlugin {
    name = "openshift-pipeline-1.0.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/openshift-pipeline/1.0.7/openshift-pipeline.hpi";
      sha256 = "1pcmqh31z0pjyfr3jh3b17ia3i4937i0wzsh93wpzz3qi8zx7rw1";
    };
  };
  "openstack-cloud-1.8" = mkJenkinsPlugin {
    name = "openstack-cloud-1.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/openstack-cloud/1.8/openstack-cloud.hpi";
      sha256 = "04rag3jb9sir8iv4l4h0h8k9rx608as8q0qrsffsn2aknv8dmmf9";
    };
  };
  "oslc-cm-1.31" = mkJenkinsPlugin {
    name = "oslc-cm-1.31";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/oslc-cm/1.31/oslc-cm.hpi";
      sha256 = "0qcxzbqnxlymn320lw4j1k9nnj3glbwa8q7s1aqlc9yj2ck1c5ld";
    };
  };
  "ownership-0.8" = mkJenkinsPlugin {
    name = "ownership-0.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ownership/0.8/ownership.hpi";
      sha256 = "0r0bivz0jqxxp5s0r7p9xf5qklk96h6bc0sx204byki1kjsakwbp";
    };
  };
  "p4-1.3.6" = mkJenkinsPlugin {
    name = "p4-1.3.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/p4/1.3.6/p4.hpi";
      sha256 = "1qjqiwvja3hncn2cjklcv1kl5n0hqkwlcn45n1yxz2din9hbaj2b";
    };
  };
  "paaslane-estimate-1.0.4" = mkJenkinsPlugin {
    name = "paaslane-estimate-1.0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/paaslane-estimate/1.0.4/paaslane-estimate.hpi";
      sha256 = "0hrr5zq4ryaa8hn66xbi5prw3dbci26blgygr9wd3lgllqncmmwg";
    };
  };
  "package-drone-0.2.2" = mkJenkinsPlugin {
    name = "package-drone-0.2.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/package-drone/0.2.2/package-drone.hpi";
      sha256 = "16zh7044y5d73f7fzw05vaa8naqm8cn479r8jsgqfzknz020qy87";
    };
  };
  "package-parameter-1.7" = mkJenkinsPlugin {
    name = "package-parameter-1.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/package-parameter/1.7/package-parameter.hpi";
      sha256 = "002nz4f5szpn4kpq6b7i61s618p6j0zdjbksx3d7l1hirr64mlai";
    };
  };
  "packagecloud-1.4" = mkJenkinsPlugin {
    name = "packagecloud-1.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/packagecloud/1.4/packagecloud.hpi";
      sha256 = "0q5wxpllzfkkx322kmy9v29ws0xgrl4pk2bkx4537xh6hp2kc7mx";
    };
  };
  "packer-1.2" = mkJenkinsPlugin {
    name = "packer-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/packer/1.2/packer.hpi";
      sha256 = "07na5s327gfdk61l2pidwkfsch0c3rkwrbzq0bxnayilxk1hs32k";
    };
  };
  "pagerduty-0.2.2" = mkJenkinsPlugin {
    name = "pagerduty-0.2.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/pagerduty/0.2.2/pagerduty.hpi";
      sha256 = "0fhpz7gcz7f9nzffxnhp0ivprhb53h8ls8pr0ng8bq54lgx3vdmm";
    };
  };
  "pam-auth-1.2" = mkJenkinsPlugin {
    name = "pam-auth-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/pam-auth/1.2/pam-auth.hpi";
      sha256 = "0lksvwmxncn5np8cjaq4ljg2z21g9gacpkryclkdvm5669jkw6q4";
    };
  };
  "parallel-test-executor-1.7" = mkJenkinsPlugin {
    name = "parallel-test-executor-1.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/parallel-test-executor/1.7/parallel-test-executor.hpi";
      sha256 = "0jwg2hhvvw4hqckc17x7iink2iyp4a1jisx1j23s4q2hwwwfjxa8";
    };
  };
  "parallels-desktop-0.3" = mkJenkinsPlugin {
    name = "parallels-desktop-0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/parallels-desktop/0.3/parallels-desktop.hpi";
      sha256 = "1d0lq91vixjhx3wi0hmzph3fijl9lakwiflpcmwyangpi8dzghsj";
    };
  };
  "parameter-pool-1.0.2" = mkJenkinsPlugin {
    name = "parameter-pool-1.0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/parameter-pool/1.0.2/parameter-pool.hpi";
      sha256 = "08sfb49iih6d6297mx4fxpbb6xj77lqyb6gvnf48in05js9rwlpc";
    };
  };
  "parameter-separator-1.0" = mkJenkinsPlugin {
    name = "parameter-separator-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/parameter-separator/1.0/parameter-separator.hpi";
      sha256 = "1qh01izbi00va0hrdhnk7j53p9gbwgiy0r08llkw9brfpfbd25l3";
    };
  };
  "parameterized-scheduler-0.2" = mkJenkinsPlugin {
    name = "parameterized-scheduler-0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/parameterized-scheduler/0.2/parameterized-scheduler.hpi";
      sha256 = "16hb6xi4i4p6wk3xy5yggvyw8n50wd1lavzxafbk39vzimxfj916";
    };
  };
  "parameterized-trigger-2.30" = mkJenkinsPlugin {
    name = "parameterized-trigger-2.30";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/parameterized-trigger/2.30/parameterized-trigger.hpi";
      sha256 = "1wfngwb0y9v5rkgs9l32jkczlgc735zpjncqi7i6y00ky44k049c";
    };
  };
  "patch-parameter-1.2" = mkJenkinsPlugin {
    name = "patch-parameter-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/patch-parameter/1.2/patch-parameter.hpi";
      sha256 = "0rhlfkjl0ci7jmian6gjavpv28yab2vk2mzfgqz2apz2jbsih2mq";
    };
  };
  "pathignore-0.6" = mkJenkinsPlugin {
    name = "pathignore-0.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/pathignore/0.6/pathignore.hpi";
      sha256 = "0gxyznhb8m5kz0rmad6xfcssrk7zc2lp19wr0nlampkipmp8xzp0";
    };
  };
  "pegdown-formatter-1.3" = mkJenkinsPlugin {
    name = "pegdown-formatter-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/pegdown-formatter/1.3/pegdown-formatter.hpi";
      sha256 = "13d8hqj9zll2rb6qqjyax1zirrjb08fsg6gp0zw5s80spymcn6zd";
    };
  };
  "pending-changes-0.3.0" = mkJenkinsPlugin {
    name = "pending-changes-0.3.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/pending-changes/0.3.0/pending-changes.hpi";
      sha256 = "00m6ynb9dyzljvih5x3i90c1zf81xjrpy635kly1r932nqvqc8v5";
    };
  };
  "people-redirector-1.3" = mkJenkinsPlugin {
    name = "people-redirector-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/people-redirector/1.3/people-redirector.hpi";
      sha256 = "09qvm322dl70yjb95j308p1qckh85f3q0wph3l2rs8xrwiji893r";
    };
  };
  "percentage-du-node-column-0.1.0" = mkJenkinsPlugin {
    name = "percentage-du-node-column-0.1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/percentage-du-node-column/0.1.0/percentage-du-node-column.hpi";
      sha256 = "131cxxccwg3q263sjqwxv3zdddil33jcprhpczj3gdr4xp84i59w";
    };
  };
  "perfectomobile-2.41.0.1" = mkJenkinsPlugin {
    name = "perfectomobile-2.41.0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/perfectomobile/2.41.0.1/perfectomobile.hpi";
      sha256 = "0s7fmiyj6zk0n3ir5r5jc2q78j9zf66bs8j3pp4avr4xa7ypvmgc";
    };
  };
  "perforce-1.3.35" = mkJenkinsPlugin {
    name = "perforce-1.3.35";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/perforce/1.3.35/perforce.hpi";
      sha256 = "1355zycb56r767d7xxaxmssml343kyphhpdzznpxwfsnl9c65vna";
    };
  };
  "performance-1.13" = mkJenkinsPlugin {
    name = "performance-1.13";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/performance/1.13/performance.hpi";
      sha256 = "04bq0nynkq8k3pwjjrndinwcrxnvwbwmqxx42njbya2liglbnh01";
    };
  };
  "perfpublisher-8.02" = mkJenkinsPlugin {
    name = "perfpublisher-8.02";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/perfpublisher/8.02/perfpublisher.hpi";
      sha256 = "18730zx3wd8w77m7adkk49v01cfh6lvqwnlrxapbdgq2b8m44yqk";
    };
  };
  "periodic-reincarnation-1.9" = mkJenkinsPlugin {
    name = "periodic-reincarnation-1.9";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/periodic-reincarnation/1.9/periodic-reincarnation.hpi";
      sha256 = "0dx069pizkjhnw2raayrn234lgp1fh6pf8im2xx6dkzhcy0gplyf";
    };
  };
  "periodicbackup-1.3" = mkJenkinsPlugin {
    name = "periodicbackup-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/periodicbackup/1.3/periodicbackup.hpi";
      sha256 = "0870zx4sdim7bb66yr5pp7gcs6pjrccv1is8hp268yykvkydfcp0";
    };
  };
  "persistent-build-queue-plugin-0.1.1" = mkJenkinsPlugin {
    name = "persistent-build-queue-plugin-0.1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/persistent-build-queue-plugin/0.1.1/persistent-build-queue-plugin.hpi";
      sha256 = "0gsmq4q8lzsprxgr1wf0k5g1h58hgcisjm0lzasa0mndnib8qwmq";
    };
  };
  "persistent-parameter-1.1" = mkJenkinsPlugin {
    name = "persistent-parameter-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/persistent-parameter/1.1/persistent-parameter.hpi";
      sha256 = "0hvfbz1wjgcm4aghd519ixw02lbmylvy79mhyhfaxfdq1yzsr07v";
    };
  };
  "persona-2.4" = mkJenkinsPlugin {
    name = "persona-2.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/persona/2.4/persona.hpi";
      sha256 = "11wjyjs5k5awsramw423nwwfiyiyh4d49190jnnfdl94sr8jh4sp";
    };
  };
  "phabricator-plugin-1.9.1" = mkJenkinsPlugin {
    name = "phabricator-plugin-1.9.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/phabricator-plugin/1.9.1/phabricator-plugin.hpi";
      sha256 = "1y65g2z2c1qxg19afqnz75z0rhsl6ccqpc1ayprnq4jhbgv7w1gl";
    };
  };
  "phing-0.13.3" = mkJenkinsPlugin {
    name = "phing-0.13.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/phing/0.13.3/phing.hpi";
      sha256 = "087fz3bpv5k7klpdba5gagh0kp2ca27ibpfm5wpgppqj8xymw208";
    };
  };
  "php-builtin-web-server-0.1" = mkJenkinsPlugin {
    name = "php-builtin-web-server-0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/php-builtin-web-server/0.1/php-builtin-web-server.hpi";
      sha256 = "1k7ij3s9z28358jzrnha0f1alxqbcwnix2c86myqbgkkkndsggrn";
    };
  };
  "php-1.0" = mkJenkinsPlugin {
    name = "php-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/php/1.0/php.hpi";
      sha256 = "1b7mi1zxczjqnppsq6hhryh320g4ir4zk040265n1n9x3v201gs0";
    };
  };
  "piketec-tpt-7.1" = mkJenkinsPlugin {
    name = "piketec-tpt-7.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/piketec-tpt/7.1/piketec-tpt.hpi";
      sha256 = "110pnjnp3xbclpg97l5kn7wkm0dvr639kfd9vpl1687v9q575pl8";
    };
  };
  "pipeline-utility-steps-1.0" = mkJenkinsPlugin {
    name = "pipeline-utility-steps-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/pipeline-utility-steps/1.0/pipeline-utility-steps.hpi";
      sha256 = "0gb2ydzfz5vg2iba1yrl67g3hkby11cviyanvaiqpgk8r26sa3zq";
    };
  };
  "pitmutation-1.0-13" = mkJenkinsPlugin {
    name = "pitmutation-1.0-13";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/pitmutation/1.0-13/pitmutation.hpi";
      sha256 = "08s8kclzg55kra5lfk4sgyvmqzhk072vb020jjjsyk72vzpnqk64";
    };
  };
  "piwikanalytics-1.1.0" = mkJenkinsPlugin {
    name = "piwikanalytics-1.1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/piwikanalytics/1.1.0/piwikanalytics.hpi";
      sha256 = "1x0xp3mkg5lam5xln62b80c2m48pnbs1791dngp940iai7k5qphh";
    };
  };
  "plain-credentials-1.1" = mkJenkinsPlugin {
    name = "plain-credentials-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/plain-credentials/1.1/plain-credentials.hpi";
      sha256 = "0zzzk44fy8qmb004wj1js9d2mpfsx78q34k7zdg8nlg6jaqdn2sp";
    };
  };
  "plasticscm-plugin-2.3" = mkJenkinsPlugin {
    name = "plasticscm-plugin-2.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/plasticscm-plugin/2.3/plasticscm-plugin.hpi";
      sha256 = "0zn2v5mpj9vkrppbq2d3l1nnd44nq5lqd2486pvagsrp7iwf2sw3";
    };
  };
  "platformlabeler-1.1" = mkJenkinsPlugin {
    name = "platformlabeler-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/platformlabeler/1.1/platformlabeler.hpi";
      sha256 = "0igsxhv8wpsxq1vxfd0qhkfalrbamcg6jy51zj6kbzrqx2kjg193";
    };
  };
  "plot-1.9" = mkJenkinsPlugin {
    name = "plot-1.9";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/plot/1.9/plot.hpi";
      sha256 = "0hr2q0mbdfnwh87l48rhc1p030xafa5pc5cki6njvvgl8b66f89d";
    };
  };
  "plugin-usage-plugin-0.3" = mkJenkinsPlugin {
    name = "plugin-usage-plugin-0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/plugin-usage-plugin/0.3/plugin-usage-plugin.hpi";
      sha256 = "080d27bwmdmnr0bixxp9a69wc081bn522xzg199yprs2l6am9rnv";
    };
  };
  "pmd-3.43" = mkJenkinsPlugin {
    name = "pmd-3.43";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/pmd/3.43/pmd.hpi";
      sha256 = "1w9gnj5m0az07z64z0dyb68k42pc81w6fa7z0x1612mkzc2xmp27";
    };
  };
  "polarion-1.3" = mkJenkinsPlugin {
    name = "polarion-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/polarion/1.3/polarion.hpi";
      sha256 = "0759qbqm44kpha5m4mgsqj5znqgk1w7z72a7fbhc9g41n1c92zlv";
    };
  };
  "poll-mailbox-trigger-plugin-1.020" = mkJenkinsPlugin {
    name = "poll-mailbox-trigger-plugin-1.020";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/poll-mailbox-trigger-plugin/1.020/poll-mailbox-trigger-plugin.hpi";
      sha256 = "1f5dafllc3z083b625sh6z8n1sm2grfsq21a427d85kymh36a716";
    };
  };
  "pollscm-1.2" = mkJenkinsPlugin {
    name = "pollscm-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/pollscm/1.2/pollscm.hpi";
      sha256 = "078396qnvjlilgx7ngbbkpz8fbi26r4j8nznzhkqirbn4jj8pihf";
    };
  };
  "pom2config-1.2" = mkJenkinsPlugin {
    name = "pom2config-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/pom2config/1.2/pom2config.hpi";
      sha256 = "0k63dphxy67z4lxb698s858y6vi6mrhmlhil8agf68ln0b8p2q1p";
    };
  };
  "port-allocator-1.8" = mkJenkinsPlugin {
    name = "port-allocator-1.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/port-allocator/1.8/port-allocator.hpi";
      sha256 = "0zzn9zggq4z9zx24lcvfq978x9b6p0dri893ilmz66q22lxina44";
    };
  };
  "post-completed-build-result-1.1" = mkJenkinsPlugin {
    name = "post-completed-build-result-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/post-completed-build-result/1.1/post-completed-build-result.hpi";
      sha256 = "0lldspajcm2g9hflh2xvhimxv6m2yzlpdw1y7h8w8w4maqp5lynn";
    };
  };
  "postbuild-task-1.8" = mkJenkinsPlugin {
    name = "postbuild-task-1.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/postbuild-task/1.8/postbuild-task.hpi";
      sha256 = "18pkv6llfz9gdzpw0r0884vh8jd5izg3w4svk6jxw3sgznbrlg50";
    };
  };
  "postbuildscript-0.17" = mkJenkinsPlugin {
    name = "postbuildscript-0.17";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/postbuildscript/0.17/postbuildscript.hpi";
      sha256 = "0vmlbb7fzgdyk3mcnzkkjfz7lr4cwi8ndx6kpva81d9c1ffgc58i";
    };
  };
  "powershell-1.3" = mkJenkinsPlugin {
    name = "powershell-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/powershell/1.3/powershell.hpi";
      sha256 = "0gl6y32750q8h0qsrv8riasd2zaxhcn2sw1pg1qxg6g7x4r8kimz";
    };
  };
  "pragprog-1.0.4" = mkJenkinsPlugin {
    name = "pragprog-1.0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/pragprog/1.0.4/pragprog.hpi";
      sha256 = "0r1bzgxpfyy8fhvdcrkzqii23x7wykfv7wri026qgxfy2k38kwrp";
    };
  };
  "preSCMbuildstep-0.3" = mkJenkinsPlugin {
    name = "preSCMbuildstep-0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/preSCMbuildstep/0.3/preSCMbuildstep.hpi";
      sha256 = "00kqdnkl88hizlzdyz2gxhlmwzy6aavkjz8f87ijhvzacrk5dp6h";
    };
  };
  "prereq-buildstep-1.1" = mkJenkinsPlugin {
    name = "prereq-buildstep-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/prereq-buildstep/1.1/prereq-buildstep.hpi";
      sha256 = "0297yshx4zlpaw3vfdw48yn6c8z0xq0zybh0f5sa4556yr6l8pbd";
    };
  };
  "pretested-integration-2.4.0" = mkJenkinsPlugin {
    name = "pretested-integration-2.4.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/pretested-integration/2.4.0/pretested-integration.hpi";
      sha256 = "0nqhsfacvxxb65c0vymb3gc99whb45zc92cg3fljd5kj2haxv1dh";
    };
  };
  "proc-cleaner-plugin-1.1" = mkJenkinsPlugin {
    name = "proc-cleaner-plugin-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/proc-cleaner-plugin/1.1/proc-cleaner-plugin.hpi";
      sha256 = "0rqjny7vs4y9509y6ii8mir192l01ni8djc63k42hx2lxk1mipz6";
    };
  };
  "progress-bar-column-plugin-1.0" = mkJenkinsPlugin {
    name = "progress-bar-column-plugin-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/progress-bar-column-plugin/1.0/progress-bar-column-plugin.hpi";
      sha256 = "1jq844ibna0f63n1s9ncqpjhkxxn5ffvdxj4nxbib1cla5jl9qd3";
    };
  };
  "project-build-times-1.2.1" = mkJenkinsPlugin {
    name = "project-build-times-1.2.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/project-build-times/1.2.1/project-build-times.hpi";
      sha256 = "1fkk5q3769md01fll34389zyv685bq550vkbqn1c0fdpa4c4vk9g";
    };
  };
  "project-description-setter-1.1" = mkJenkinsPlugin {
    name = "project-description-setter-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/project-description-setter/1.1/project-description-setter.hpi";
      sha256 = "18xly882pvrmlss7l0y43nws1a5mndf4k8mmbf86j3p9w7c4g0nq";
    };
  };
  "project-health-report-1.2" = mkJenkinsPlugin {
    name = "project-health-report-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/project-health-report/1.2/project-health-report.hpi";
      sha256 = "139m337c54d2g1w603xwydms3g925vkndm21mx5jz0f4xxv79mx3";
    };
  };
  "project-inheritance-1.5.3" = mkJenkinsPlugin {
    name = "project-inheritance-1.5.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/project-inheritance/1.5.3/project-inheritance.hpi";
      sha256 = "1rqz8wa39y2dq8rjnc48b5f8fbv9yj621pk257p31hsi0kjbv2ir";
    };
  };
  "project-stats-plugin-0.4" = mkJenkinsPlugin {
    name = "project-stats-plugin-0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/project-stats-plugin/0.4/project-stats-plugin.hpi";
      sha256 = "1caccz9p271wsakrxh24gqggy2gi2ng6mrrjjcagvqd0q3gbg8vd";
    };
  };
  "promoted-builds-simple-1.9" = mkJenkinsPlugin {
    name = "promoted-builds-simple-1.9";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/promoted-builds-simple/1.9/promoted-builds-simple.hpi";
      sha256 = "0aqbmm4xc238j303ff757k9080hxa3pf4hzkk9zdkbmbr194r003";
    };
  };
  "promoted-builds-2.24.1" = mkJenkinsPlugin {
    name = "promoted-builds-2.24.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/promoted-builds/2.24.1/promoted-builds.hpi";
      sha256 = "145j1f6zxz1hck4lvcbm0dkqpwxkfzz3749mvazr73ihafpv9xl3";
    };
  };
  "proxmox-0.2.1" = mkJenkinsPlugin {
    name = "proxmox-0.2.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/proxmox/0.2.1/proxmox.hpi";
      sha256 = "0z277mlpmrii2f0fqdqp3h73lj8hiha8h02zpq9wzkzjdyn5j375";
    };
  };
  "prqa-plugin-2.0.12" = mkJenkinsPlugin {
    name = "prqa-plugin-2.0.12";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/prqa-plugin/2.0.12/prqa-plugin.hpi";
      sha256 = "07pc2m7y3anpgpmx7rvss9lhp6b11fzk40c5m37kn43igfw5ffik";
    };
  };
  "pry-1.1" = mkJenkinsPlugin {
    name = "pry-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/pry/1.1/pry.hpi";
      sha256 = "047nggnl8x4g3w3fpryzpm57d6l9ah0d5ywhalgvnap5fpgcak4y";
    };
  };
  "publish-over-cifs-0.3" = mkJenkinsPlugin {
    name = "publish-over-cifs-0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/publish-over-cifs/0.3/publish-over-cifs.hpi";
      sha256 = "01pm82pk0vnb8h0gn1l1qrg02wx13v6mgg275yklsf03yg26rgmz";
    };
  };
  "publish-over-dropbox-1.0.5" = mkJenkinsPlugin {
    name = "publish-over-dropbox-1.0.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/publish-over-dropbox/1.0.5/publish-over-dropbox.hpi";
      sha256 = "09v7r9wvnrc4421188i5wzg569rq3y8bzfx50q2lvn1lv8dh2hsh";
    };
  };
  "publish-over-ftp-1.11" = mkJenkinsPlugin {
    name = "publish-over-ftp-1.11";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/publish-over-ftp/1.11/publish-over-ftp.hpi";
      sha256 = "1b1pdm3k65fggc0mck4hax2qa1q8wfrn5vdcygcmyqkbq3py87w2";
    };
  };
  "publish-over-ssh-1.13" = mkJenkinsPlugin {
    name = "publish-over-ssh-1.13";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/publish-over-ssh/1.13/publish-over-ssh.hpi";
      sha256 = "0wfhhkxil2c4vm437qcy7b6pqqp6pcnnvm8jh4lh5aqqqprb9pw4";
    };
  };
  "puppet-1.1" = mkJenkinsPlugin {
    name = "puppet-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/puppet/1.1/puppet.hpi";
      sha256 = "0lwcg7z8bwgk927lvfkawxp8nz7ww99l7gws97x1c5lgw51g5s65";
    };
  };
  "purge-build-queue-plugin-1.0" = mkJenkinsPlugin {
    name = "purge-build-queue-plugin-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/purge-build-queue-plugin/1.0/purge-build-queue-plugin.hpi";
      sha256 = "1m2lfh7avh4cwa5ddlz52407i3c6blry7f8p6ssgh6l5w1jpy30b";
    };
  };
  "purge-job-history-1.1" = mkJenkinsPlugin {
    name = "purge-job-history-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/purge-job-history/1.1/purge-job-history.hpi";
      sha256 = "11v5pwg9fdpxymvrjz7h6nf5nn78a9drm9cilzxz1k5501llzlai";
    };
  };
  "pvcs_scm-1.1" = mkJenkinsPlugin {
    name = "pvcs_scm-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/pvcs_scm/1.1/pvcs_scm.hpi";
      sha256 = "19iilb8rfx0x0zq371vpn7mlh9rqmjx9i11kb90aaa7bf31v1blc";
    };
  };
  "pwauth-0.4" = mkJenkinsPlugin {
    name = "pwauth-0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/pwauth/0.4/pwauth.hpi";
      sha256 = "06vff0ym8sg27h7rs96av28g58apb704xg9r3v93gbmyg8jnms50";
    };
  };
  "pxe-1.5" = mkJenkinsPlugin {
    name = "pxe-1.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/pxe/1.5/pxe.hpi";
      sha256 = "1fzma00mpmq3m27i6g6xzc3d1zfnbfzc7fvnv2b2szn1p1lyr25i";
    };
  };
  "pyenv-0.0.7" = mkJenkinsPlugin {
    name = "pyenv-0.0.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/pyenv/0.0.7/pyenv.hpi";
      sha256 = "0fa0a29bfa7g6zbzxvdac910jlvm9dxknmzq8q4kvx5ffziyzj8m";
    };
  };
  "python-wrapper-1.0.3" = mkJenkinsPlugin {
    name = "python-wrapper-1.0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/python-wrapper/1.0.3/python-wrapper.hpi";
      sha256 = "1dpscwqls8f67l4908z9dsr3wbdg5yliscqdp225r45rdkiznlns";
    };
  };
  "python-1.3" = mkJenkinsPlugin {
    name = "python-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/python/1.3/python.hpi";
      sha256 = "0qrks8h4y228bmfj1gs59nd97c36bz3kr7pjkw53bchixm25i5c1";
    };
  };
  "qc-1.2.1" = mkJenkinsPlugin {
    name = "qc-1.2.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/qc/1.2.1/qc.hpi";
      sha256 = "1ivwwxpbvp8wy9vrn2kxhnb8lhzypbg6hyfdq47vxk5f6x5a4z51";
    };
  };
  "qftest-1.0.0" = mkJenkinsPlugin {
    name = "qftest-1.0.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/qftest/1.0.0/qftest.hpi";
      sha256 = "15hvnqicyc1jras12v1wgc33633c9z71zmw03fq4bhpxb7kg0yi5";
    };
  };
  "qtest-1.1.5" = mkJenkinsPlugin {
    name = "qtest-1.1.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/qtest/1.1.5/qtest.hpi";
      sha256 = "01yziqflrld3zkpfh7i2d26isnfc467j905gjra5blrw110m9y11";
    };
  };
  "quayio-trigger-0.1" = mkJenkinsPlugin {
    name = "quayio-trigger-0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/quayio-trigger/0.1/quayio-trigger.hpi";
      sha256 = "1q0h34mkh7vz1cis58hgdfy10wgn3ckm5pafmc69znvmmrr2d44y";
    };
  };
  "queue-cleanup-1.0" = mkJenkinsPlugin {
    name = "queue-cleanup-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/queue-cleanup/1.0/queue-cleanup.hpi";
      sha256 = "095bfpjhfm68f6sh65cnijriy5ymchn5q6gv2d1i75xiawhvzk2q";
    };
  };
  "r-0.2" = mkJenkinsPlugin {
    name = "r-0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/r/0.2/r.hpi";
      sha256 = "0ndw6gkz1mccsfw72nnqb68grzz65paylyxq9v5gsp90wb78iwha";
    };
  };
  "rabbitmq-build-trigger-2.3" = mkJenkinsPlugin {
    name = "rabbitmq-build-trigger-2.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/rabbitmq-build-trigger/2.3/rabbitmq-build-trigger.hpi";
      sha256 = "0rkil9ngqm3bq800n579cmq1jb0prkzns2xvndk5jkz1sipdlslj";
    };
  };
  "rabbitmq-consumer-2.7" = mkJenkinsPlugin {
    name = "rabbitmq-consumer-2.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/rabbitmq-consumer/2.7/rabbitmq-consumer.hpi";
      sha256 = "1fj4qc9l7r19pfvd0l27haw47aaaq72mwzlj61lfk1yxp0jh406i";
    };
  };
  "rad-builder-1.1.4" = mkJenkinsPlugin {
    name = "rad-builder-1.1.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/rad-builder/1.1.4/rad-builder.hpi";
      sha256 = "108k1wlx9pi8qagdd9c5ng9z4wm480rik9wxzwrdcy3vbb93mxh2";
    };
  };
  "radiatorviewplugin-1.25" = mkJenkinsPlugin {
    name = "radiatorviewplugin-1.25";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/radiatorviewplugin/1.25/radiatorviewplugin.hpi";
      sha256 = "0p84mqfmv0gvgnrjg54frk9p92gkm1r79d0qaivg3bbmmmd9js6c";
    };
  };
  "rake-1.8.0" = mkJenkinsPlugin {
    name = "rake-1.8.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/rake/1.8.0/rake.hpi";
      sha256 = "17xi5yb4k3hqv9z2f9y80as9lbpm2s76fj1xpp3mps9hjlq0s92x";
    };
  };
  "rally-plugin-2.2.1" = mkJenkinsPlugin {
    name = "rally-plugin-2.2.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/rally-plugin/2.2.1/rally-plugin.hpi";
      sha256 = "12032ph9cda9k41mwamayhdyr9bmwndqb1bid9akhhs2871rc8p1";
    };
  };
  "random-job-builder-1.0" = mkJenkinsPlugin {
    name = "random-job-builder-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/random-job-builder/1.0/random-job-builder.hpi";
      sha256 = "1wm1y7qplfb4ip3igq7jg7m6ggbw2k1502qih7avq287fvx9p8lw";
    };
  };
  "random-string-parameter-1.0" = mkJenkinsPlugin {
    name = "random-string-parameter-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/random-string-parameter/1.0/random-string-parameter.hpi";
      sha256 = "1va4qb5llahzlnf72jldw9x3aykfkgagjpl8vs8c3d7bs17kfd9z";
    };
  };
  "rapiddeploy-jenkins-3.6" = mkJenkinsPlugin {
    name = "rapiddeploy-jenkins-3.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/rapiddeploy-jenkins/3.6/rapiddeploy-jenkins.hpi";
      sha256 = "1jkghw8p1c8zzhr5f80z6xw2f7mwp4xmgfhq2p2lnk9si8drc8s2";
    };
  };
  "rbenv-0.0.16" = mkJenkinsPlugin {
    name = "rbenv-0.0.16";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/rbenv/0.0.16/rbenv.hpi";
      sha256 = "1id4ylkkmzvr1m99cxzv8zr469w6sl7983cck71qghniq48z07nf";
    };
  };
  "reactor-plugin-0.1.2" = mkJenkinsPlugin {
    name = "reactor-plugin-0.1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/reactor-plugin/0.1.2/reactor-plugin.hpi";
      sha256 = "1n37q0nrj5c7m50rl9jhi1wji65cgya8x44bhl55c6nr1hv7lvgl";
    };
  };
  "read-only-configurations-1.10" = mkJenkinsPlugin {
    name = "read-only-configurations-1.10";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/read-only-configurations/1.10/read-only-configurations.hpi";
      sha256 = "18amy0n3panqccbhm81bps9mm5shpwmzf8cxk4mj8999ydl9ij02";
    };
  };
  "readonly-parameters-1.0.0" = mkJenkinsPlugin {
    name = "readonly-parameters-1.0.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/readonly-parameters/1.0.0/readonly-parameters.hpi";
      sha256 = "0llw0p67q667jr4wvdfaxmw2qxl6xx3c1x0wlqzg6kx4vxphjpix";
    };
  };
  "rebuild-1.25" = mkJenkinsPlugin {
    name = "rebuild-1.25";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/rebuild/1.25/rebuild.hpi";
      sha256 = "114pkr48ba139rl8gfjkx7c8ca4fkc26k9gqnrjsmzwhngslshij";
    };
  };
  "recipe-1.2" = mkJenkinsPlugin {
    name = "recipe-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/recipe/1.2/recipe.hpi";
      sha256 = "1a3nrw2bal4lw6az369kxh3550jk2x73gz6k0kimwya5pcj04xs7";
    };
  };
  "redgate-sql-ci-1.0.8" = mkJenkinsPlugin {
    name = "redgate-sql-ci-1.0.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/redgate-sql-ci/1.0.8/redgate-sql-ci.hpi";
      sha256 = "05kv00ry70vv04rjjwigg6crx24fcb5fai0jw8hdz0fdx8s5yxpf";
    };
  };
  "redmine-0.15" = mkJenkinsPlugin {
    name = "redmine-0.15";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/redmine/0.15/redmine.hpi";
      sha256 = "0b3b196b8cjqldgl02jn6ws55bjk5cb5192d20s67ppdb9gg7jym";
    };
  };
  "refit-0.3.1" = mkJenkinsPlugin {
    name = "refit-0.3.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/refit/0.3.1/refit.hpi";
      sha256 = "1dq1w3xf8qm7p96dk34x35bbbpj82nyi5w330jdv86z10mizfmy4";
    };
  };
  "regexemail-0.3" = mkJenkinsPlugin {
    name = "regexemail-0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/regexemail/0.3/regexemail.hpi";
      sha256 = "1b4imsxqz2ignbrp98q3rv17m5xslrdq4fjw8gnzf6v1aapx1cl7";
    };
  };
  "regression-report-plugin-1.5" = mkJenkinsPlugin {
    name = "regression-report-plugin-1.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/regression-report-plugin/1.5/regression-report-plugin.hpi";
      sha256 = "0rl70yxgbw51658zfapxml9lkvax1dkz3y8vb2jzrs1gm3xbp40z";
    };
  };
  "release-2.5.4" = mkJenkinsPlugin {
    name = "release-2.5.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/release/2.5.4/release.hpi";
      sha256 = "0v7alc0ccj5ihx1py2yq6y1yjlx8721whjfnxa2p7vfz5mzlp81r";
    };
  };
  "relution-publisher-1.22" = mkJenkinsPlugin {
    name = "relution-publisher-1.22";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/relution-publisher/1.22/relution-publisher.hpi";
      sha256 = "1r6z25z5cvd9w20kj10zpanij41zxidcjd5m9lrklgrf6vzpxzaa";
    };
  };
  "remote-jobs-view-plugin-0.0.3" = mkJenkinsPlugin {
    name = "remote-jobs-view-plugin-0.0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/remote-jobs-view-plugin/0.0.3/remote-jobs-view-plugin.hpi";
      sha256 = "06ji0sf0j42admqqckar2sz8kpk4ni61px9avlikgsc1dg9frpcl";
    };
  };
  "remote-terminal-access-1.6" = mkJenkinsPlugin {
    name = "remote-terminal-access-1.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/remote-terminal-access/1.6/remote-terminal-access.hpi";
      sha256 = "10b0hwj1d0w544vlbr4y81a9bw6j4x04jsmnyappxnx0rdsmbvqf";
    };
  };
  "repo-1.9.0" = mkJenkinsPlugin {
    name = "repo-1.9.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/repo/1.9.0/repo.hpi";
      sha256 = "0lmi7ygamsxgr5kg1pzzp14012p6bjvn038bk36dmdsm23bjfxdz";
    };
  };
  "repository-connector-1.1.2" = mkJenkinsPlugin {
    name = "repository-connector-1.1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/repository-connector/1.1.2/repository-connector.hpi";
      sha256 = "0kcjkx9cfmxjdayjxg6f4pr22v03mqj8aaizk57246xqlnz0g5ak";
    };
  };
  "repository-1.3" = mkJenkinsPlugin {
    name = "repository-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/repository/1.3/repository.hpi";
      sha256 = "0v6h8mrhr3fqj3n48whc2v74fpcrvzmfijdw4ics595lz3fx2nvb";
    };
  };
  "reverse-proxy-auth-plugin-1.5" = mkJenkinsPlugin {
    name = "reverse-proxy-auth-plugin-1.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/reverse-proxy-auth-plugin/1.5/reverse-proxy-auth-plugin.hpi";
      sha256 = "06k0njgrjrx3ii9zxak8ab7hr5lflid05xc448ahx53yijkak6x7";
    };
  };
  "reviewboard-1.0.1" = mkJenkinsPlugin {
    name = "reviewboard-1.0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/reviewboard/1.0.1/reviewboard.hpi";
      sha256 = "0vxzpr3b3yzxaiiv9q8iqacjm6sl63008lai0i4y64jrafbizj41";
    };
  };
  "rhnpush-plugin-0.4.1" = mkJenkinsPlugin {
    name = "rhnpush-plugin-0.4.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/rhnpush-plugin/0.4.1/rhnpush-plugin.hpi";
      sha256 = "0rav3l2zn8qkfk2c4qh2sppfzb0ajds3cp2r8gsi3j7qm1gg4q23";
    };
  };
  "rich-text-publisher-plugin-1.3" = mkJenkinsPlugin {
    name = "rich-text-publisher-plugin-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/rich-text-publisher-plugin/1.3/rich-text-publisher-plugin.hpi";
      sha256 = "130gxki9c4lx2fjjcqhvcbdqsi0d8pcwzjihly8gdxh0fqqcw244";
    };
  };
  "robot-1.6.2" = mkJenkinsPlugin {
    name = "robot-1.6.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/robot/1.6.2/robot.hpi";
      sha256 = "1q7zdprcva02807gp43713xix44jkmps6y6xfy2zb9x8xs5x2jaz";
    };
  };
  "role-strategy-2.2.0" = mkJenkinsPlugin {
    name = "role-strategy-2.2.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/role-strategy/2.2.0/role-strategy.hpi";
      sha256 = "1gi5brapj7v36bs7k8s2ra1lydvhxh1r5sfp8wlr612nnfmpryid";
    };
  };
  "rpmsign-plugin-0.4.6" = mkJenkinsPlugin {
    name = "rpmsign-plugin-0.4.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/rpmsign-plugin/0.4.6/rpmsign-plugin.hpi";
      sha256 = "1r1qfsby9hsjkbzm4vzyz0sx24jn8p6w6hr2c7r1lwmhk7hk7ad0";
    };
  };
  "rqm-plugin-2.8" = mkJenkinsPlugin {
    name = "rqm-plugin-2.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/rqm-plugin/2.8/rqm-plugin.hpi";
      sha256 = "0zs7vwq7nqcidmwlwz4rbkpr30r8kfy7fn6dg2m5mj1lxls1r12h";
    };
  };
  "rrod-1.1.0" = mkJenkinsPlugin {
    name = "rrod-1.1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/rrod/1.1.0/rrod.hpi";
      sha256 = "181mxmsd3d5kkhqlp33d7png85a0rwzmsjilqvwscjmy43hja4v7";
    };
  };
  "ruby-runtime-0.12" = mkJenkinsPlugin {
    name = "ruby-runtime-0.12";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ruby-runtime/0.12/ruby-runtime.hpi";
      sha256 = "0m23s30frn7hvrlxscia2psncb13m79kxkvijmnk36bs4dlsmypq";
    };
  };
  "ruby-1.2" = mkJenkinsPlugin {
    name = "ruby-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ruby/1.2/ruby.hpi";
      sha256 = "1jgiipq9pf314fpn54mk2gissr1i3vfhh87bqrfkxz0wd2vkylb7";
    };
  };
  "rubyMetrics-1.6.3" = mkJenkinsPlugin {
    name = "rubyMetrics-1.6.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/rubyMetrics/1.6.3/rubyMetrics.hpi";
      sha256 = "1da5a5c7i4afz9lk4md3v7vry37z8jscn1lj09wjpyd27k7fk32y";
    };
  };
  "rubymotion-1.12" = mkJenkinsPlugin {
    name = "rubymotion-1.12";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/rubymotion/1.12/rubymotion.hpi";
      sha256 = "1dj05hfhlvpwgr6xjq6lnp792b5ibb6x89nrivbnkbbkk3bplnva";
    };
  };
  "run-condition-extras-0.2" = mkJenkinsPlugin {
    name = "run-condition-extras-0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/run-condition-extras/0.2/run-condition-extras.hpi";
      sha256 = "0qvrmk144ha62d6rkgjr8pyyqll0w3cjfz52rfg6d1xa2qgfmxdn";
    };
  };
  "run-condition-1.0" = mkJenkinsPlugin {
    name = "run-condition-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/run-condition/1.0/run-condition.hpi";
      sha256 = "1yw02y4l3xj5xdpy1ka5s474g1fyyyc6z1ad8222f871ppsfnmaf";
    };
  };
  "rundeck-3.5.1" = mkJenkinsPlugin {
    name = "rundeck-3.5.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/rundeck/3.5.1/rundeck.hpi";
      sha256 = "0p9khfrmwxqwkpkb9slg5wa4rn0mdbmcajqhwb88l6wqaadgmja6";
    };
  };
  "runscope-1.45" = mkJenkinsPlugin {
    name = "runscope-1.45";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/runscope/1.45/runscope.hpi";
      sha256 = "0005p2kxjp3wzlpjmphzn055z8k8hlgnpjqzn7xrp178p0fxqwxi";
    };
  };
  "rusalad-plugin-1.0.8" = mkJenkinsPlugin {
    name = "rusalad-plugin-1.0.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/rusalad-plugin/1.0.8/rusalad-plugin.hpi";
      sha256 = "0jhw0mgcpgia2vwf14gpgigx1hlnv1i1sh7jf867hrc0wvcv7sw6";
    };
  };
  "rvm-0.4" = mkJenkinsPlugin {
    name = "rvm-0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/rvm/0.4/rvm.hpi";
      sha256 = "10mxjlw1jg8jm9d3k593k9x5amvyb48mrnqm4v2jpnmkp9i732p3";
    };
  };
  "s3-0.8" = mkJenkinsPlugin {
    name = "s3-0.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/s3/0.8/s3.hpi";
      sha256 = "0pyb2m7xkgz6sb99zllgjrmjjxvsw0gp7xnzy0snnnp49f9lz8b7";
    };
  };
  "saferestart-0.3" = mkJenkinsPlugin {
    name = "saferestart-0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/saferestart/0.3/saferestart.hpi";
      sha256 = "0n2p425gv6zr29kp2vhbmj35ffsn3ysy9qvfcz0r5579mfd87m00";
    };
  };
  "sahagin-0.8.2" = mkJenkinsPlugin {
    name = "sahagin-0.8.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/sahagin/0.8.2/sahagin.hpi";
      sha256 = "01998a6pgwv10mm4xhr9l4893z26qhprldadbwwasndcg7hfwdcr";
    };
  };
  "saltstack-1.6.0" = mkJenkinsPlugin {
    name = "saltstack-1.6.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/saltstack/1.6.0/saltstack.hpi";
      sha256 = "183l2bivlqlhdkcqj7v97qp6v9q1iysv96pcbvkkm801p1ll1czs";
    };
  };
  "sametime-0.4" = mkJenkinsPlugin {
    name = "sametime-0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/sametime/0.4/sametime.hpi";
      sha256 = "0dmrnraasc47njxaazckb04czb4wdga1dbb7jzkljzqbj4dy685m";
    };
  };
  "saml-0.4" = mkJenkinsPlugin {
    name = "saml-0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/saml/0.4/saml.hpi";
      sha256 = "0aljwcy02azvwzqv64qlms0acxzi4lwx041xkb29d5z9mrhxcqji";
    };
  };
  "sasunit-plugin-1.024" = mkJenkinsPlugin {
    name = "sasunit-plugin-1.024";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/sasunit-plugin/1.024/sasunit-plugin.hpi";
      sha256 = "05mh3y22i6dg83c1in82c9aazdabxc2fz9scc7qbahphnf5qm9hj";
    };
  };
  "sauce-ondemand-1.149" = mkJenkinsPlugin {
    name = "sauce-ondemand-1.149";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/sauce-ondemand/1.149/sauce-ondemand.hpi";
      sha256 = "1dhsf1ms63h0qppdni0hbz6k56rmnfrgbrk6p5r9ikrghw6dg8mz";
    };
  };
  "sbt-1.5" = mkJenkinsPlugin {
    name = "sbt-1.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/sbt/1.5/sbt.hpi";
      sha256 = "1lsrjhwn4dkl1mw5f0zxhn6sdqws63v5smldfpwrmyn7w8s0vjfc";
    };
  };
  "scala-junit-name-decoder-1.0" = mkJenkinsPlugin {
    name = "scala-junit-name-decoder-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/scala-junit-name-decoder/1.0/scala-junit-name-decoder.hpi";
      sha256 = "118sxvirqxk87nk542vjx5h5fx21mdzf6yxk8p0dllq8pvjp0cx9";
    };
  };
  "schedule-build-0.3.4" = mkJenkinsPlugin {
    name = "schedule-build-0.3.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/schedule-build/0.3.4/schedule-build.hpi";
      sha256 = "1rargd5rjz2hjjnmjjg13d0bx7kbwlqi1y9f24dgyl0qv3x219k9";
    };
  };
  "scm-api-1.0" = mkJenkinsPlugin {
    name = "scm-api-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/scm-api/1.0/scm-api.hpi";
      sha256 = "1xzdm21qv113brhafj8fg10myyvbkspqa46w8m74yn691fqprq6s";
    };
  };
  "scm-sync-configuration-0.0.9" = mkJenkinsPlugin {
    name = "scm-sync-configuration-0.0.9";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/scm-sync-configuration/0.0.9/scm-sync-configuration.hpi";
      sha256 = "1lcb63ypcz6h2v6bc96shyi9r0fz2xlhh90hvh7kazm3l94blcii";
    };
  };
  "scm2job-2.4" = mkJenkinsPlugin {
    name = "scm2job-2.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/scm2job/2.4/scm2job.hpi";
      sha256 = "0fqx67jyln9s1bj6hj9w8p4wmfx7kb1lp5g4x9iwaq7cl38mf2y1";
    };
  };
  "scons-0.4" = mkJenkinsPlugin {
    name = "scons-0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/scons/0.4/scons.hpi";
      sha256 = "1c18c6fm608bgki0652zpjcz250lm1409bakd68y6gvcc71nhs4a";
    };
  };
  "scoring-load-balancer-1.0.1" = mkJenkinsPlugin {
    name = "scoring-load-balancer-1.0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/scoring-load-balancer/1.0.1/scoring-load-balancer.hpi";
      sha256 = "18yk9ml4dsq14s8nhh8cf740ji1wxa1mxi6kfasayiz38llrs8m7";
    };
  };
  "scoverage-1.3.0" = mkJenkinsPlugin {
    name = "scoverage-1.3.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/scoverage/1.3.0/scoverage.hpi";
      sha256 = "0kq857dd7dqz7g15hd7yks723bcvzwygxl3h3vm3z0bipv82ahwc";
    };
  };
  "scp-1.8" = mkJenkinsPlugin {
    name = "scp-1.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/scp/1.8/scp.hpi";
      sha256 = "07m27xmmrs82qb1n20h01wm0i0kw7nphxgdfdjg7lwxi106kgfam";
    };
  };
  "screenshot-1.1" = mkJenkinsPlugin {
    name = "screenshot-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/screenshot/1.1/screenshot.hpi";
      sha256 = "0vwiwjsc472j54mz6wrn34wlmi59kqdcm7db430qjzxsr1dq6n3x";
    };
  };
  "script-realm-1.5" = mkJenkinsPlugin {
    name = "script-realm-1.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/script-realm/1.5/script-realm.hpi";
      sha256 = "1fkfb48d3g9j0g78siv23r35r1yjjxd5f20rnjlzb1lx3kixjbml";
    };
  };
  "script-scm-1.18" = mkJenkinsPlugin {
    name = "script-scm-1.18";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/script-scm/1.18/script-scm.hpi";
      sha256 = "10knjgi4gl58aivr92zcf4lfxr325zfy1r3msl1iqmp3qk0vnsh9";
    };
  };
  "script-security-1.17" = mkJenkinsPlugin {
    name = "script-security-1.17";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/script-security/1.17/script-security.hpi";
      sha256 = "0icbnrpxvivs4x9py75ln7ib7dw241ixq8z9jvgfrxx2lcmv3fpf";
    };
  };
  "scripted-cloud-plugin-0.12" = mkJenkinsPlugin {
    name = "scripted-cloud-plugin-0.12";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/scripted-cloud-plugin/0.12/scripted-cloud-plugin.hpi";
      sha256 = "1qqjwa4bng2glcrm5qg1x0cpxf14prc93simfg39c74d39gn7z00";
    };
  };
  "scriptler-2.9" = mkJenkinsPlugin {
    name = "scriptler-2.9";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/scriptler/2.9/scriptler.hpi";
      sha256 = "027c19zmj9z6vjq0g2mapf6j9wiwgycjmr2x025dp064appbbm8i";
    };
  };
  "scripttrigger-0.32" = mkJenkinsPlugin {
    name = "scripttrigger-0.32";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/scripttrigger/0.32/scripttrigger.hpi";
      sha256 = "10vvysy66xkl125p5ax9z3l85464nd3v3xsibkqvhy9rak2in3al";
    };
  };
  "search-all-results-plugin-1.0" = mkJenkinsPlugin {
    name = "search-all-results-plugin-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/search-all-results-plugin/1.0/search-all-results-plugin.hpi";
      sha256 = "0r9glfl45f2njpl406ib5vcw1prby1ry41bkz3732bhgk3npc6rp";
    };
  };
  "secondary-timestamper-plugin-1.1" = mkJenkinsPlugin {
    name = "secondary-timestamper-plugin-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/secondary-timestamper-plugin/1.1/secondary-timestamper-plugin.hpi";
      sha256 = "1m0djabbshfvzd5ichc5bkhwhi982ndprmzgwkkdmqrkgnnp0f8j";
    };
  };
  "sectioned-view-1.20" = mkJenkinsPlugin {
    name = "sectioned-view-1.20";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/sectioned-view/1.20/sectioned-view.hpi";
      sha256 = "0hljfa5gx7pgyl92bsmmg29n88pcdmdvkvn7qvcixafvh1zc95l0";
    };
  };
  "secure-requester-whitelist-1.0" = mkJenkinsPlugin {
    name = "secure-requester-whitelist-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/secure-requester-whitelist/1.0/secure-requester-whitelist.hpi";
      sha256 = "1bapskf9wwmmnqawcd912b730mjiiscxq7pp5jz64q83bncvizz4";
    };
  };
  "seed-0.18.0" = mkJenkinsPlugin {
    name = "seed-0.18.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/seed/0.18.0/seed.hpi";
      sha256 = "0qrg4wwa8s1glfgc59pig8qa6kam4q0lh101clmmzn0wd2070gdz";
    };
  };
  "selected-tests-executor-1.3.3" = mkJenkinsPlugin {
    name = "selected-tests-executor-1.3.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/selected-tests-executor/1.3.3/selected-tests-executor.hpi";
      sha256 = "1zgqmb2jchsfbmc0l7jywd4b2pbaip9mbhqc9c8cazbsk8zdhnqi";
    };
  };
  "selection-tasks-plugin-1.0" = mkJenkinsPlugin {
    name = "selection-tasks-plugin-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/selection-tasks-plugin/1.0/selection-tasks-plugin.hpi";
      sha256 = "09b03wjk68lwj90mnsanf0h4cmrjs2lr27my1xfqkns2961khgdf";
    };
  };
  "selenium-aes-0.5" = mkJenkinsPlugin {
    name = "selenium-aes-0.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/selenium-aes/0.5/selenium-aes.hpi";
      sha256 = "1lzxiwnmxq6brfk2ly0qmivz6vsg0nbb2fzmrjhixhjbz07r4ahr";
    };
  };
  "selenium-axis-0.0.6" = mkJenkinsPlugin {
    name = "selenium-axis-0.0.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/selenium-axis/0.0.6/selenium-axis.hpi";
      sha256 = "1q17wbx7r6acmzvbdkh5qas4w6kpz5nsg6zz8xzxmlgd9ma9nzsp";
    };
  };
  "selenium-builder-1.14" = mkJenkinsPlugin {
    name = "selenium-builder-1.14";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/selenium-builder/1.14/selenium-builder.hpi";
      sha256 = "1czin5k0y85ighlprh75rkpfggay7d3fbakzfmad5z2ki6bkxwbm";
    };
  };
  "selenium-2.4.1" = mkJenkinsPlugin {
    name = "selenium-2.4.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/selenium/2.4.1/selenium.hpi";
      sha256 = "1sdwxl4hvvzc5kqscfpq08m3z9cw7q8qii49d9zd4x69rjgil7m9";
    };
  };
  "seleniumhq-0.4" = mkJenkinsPlugin {
    name = "seleniumhq-0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/seleniumhq/0.4/seleniumhq.hpi";
      sha256 = "0xv0rs5jnyc1i2ky2wizgavzcyb1xpisa8yb73k71f0fif0nyfin";
    };
  };
  "seleniumhtmlreport-1.0" = mkJenkinsPlugin {
    name = "seleniumhtmlreport-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/seleniumhtmlreport/1.0/seleniumhtmlreport.hpi";
      sha256 = "1y7bkc8g8yxyrbkrsj5db02a43m4f0x117hfphxfpks974z05v0r";
    };
  };
  "seleniumrc-plugin-1.0" = mkJenkinsPlugin {
    name = "seleniumrc-plugin-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/seleniumrc-plugin/1.0/seleniumrc-plugin.hpi";
      sha256 = "0ba0m3w58c9vrskgx4jvqf8ycmcxbdpmxg5r64m9zay0zly7qy8j";
    };
  };
  "selfie-trigger-plugin-1.0" = mkJenkinsPlugin {
    name = "selfie-trigger-plugin-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/selfie-trigger-plugin/1.0/selfie-trigger-plugin.hpi";
      sha256 = "0f7ylnv8ix3xcddizc7a3qmh1wy041g78jyc0k7qkawa05jhsg5g";
    };
  };
  "semantic-versioning-plugin-1.10" = mkJenkinsPlugin {
    name = "semantic-versioning-plugin-1.10";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/semantic-versioning-plugin/1.10/semantic-versioning-plugin.hpi";
      sha256 = "0qwqlrfq6kzznihhr30q9451lsyv6szrdc89h08xwzg89adfzqym";
    };
  };
  "send-stacktrace-to-eclipse-plugin-1.7" = mkJenkinsPlugin {
    name = "send-stacktrace-to-eclipse-plugin-1.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/send-stacktrace-to-eclipse-plugin/1.7/send-stacktrace-to-eclipse-plugin.hpi";
      sha256 = "06xib43x7iqyl57l1hhf1a5d0v1963x5ix5b6v6lqc26xbvdsday";
    };
  };
  "serenity-1.0" = mkJenkinsPlugin {
    name = "serenity-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/serenity/1.0/serenity.hpi";
      sha256 = "18v0s6dbvak83pnj2qxzidwgj1qh0l9a821vpg5xkz079b6ffdr1";
    };
  };
  "sfee-1.0.4" = mkJenkinsPlugin {
    name = "sfee-1.0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/sfee/1.0.4/sfee.hpi";
      sha256 = "0vhhrb8v8xphh8iz2s9zjwv1yhdh189zzdc390szqbgfy6k2hw5b";
    };
  };
  "shared-objects-0.44" = mkJenkinsPlugin {
    name = "shared-objects-0.44";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/shared-objects/0.44/shared-objects.hpi";
      sha256 = "0h7r26alz4qvqgss845m5m15m2faq5dhgwvg4fs5pi5chvhhrfhr";
    };
  };
  "shared-workspace-1.0.2" = mkJenkinsPlugin {
    name = "shared-workspace-1.0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/shared-workspace/1.0.2/shared-workspace.hpi";
      sha256 = "1v2dabpp36yd5idc5188n6a19qghgb1zxpv51dgcaahmh62a6aqp";
    };
  };
  "shelve-project-plugin-1.5" = mkJenkinsPlugin {
    name = "shelve-project-plugin-1.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/shelve-project-plugin/1.5/shelve-project-plugin.hpi";
      sha256 = "0gddjkk7rc9jnwkyjz31fzbvfvjw6yry8laxy5kwlsqzsj8hcn4v";
    };
  };
  "shiningpanda-0.22" = mkJenkinsPlugin {
    name = "shiningpanda-0.22";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/shiningpanda/0.22/shiningpanda.hpi";
      sha256 = "0paqpjl780mv5jg0l36r4viwdshh2mgg722x28ymbj73xzxjqxcb";
    };
  };
  "short-workspace-path-0.1" = mkJenkinsPlugin {
    name = "short-workspace-path-0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/short-workspace-path/0.1/short-workspace-path.hpi";
      sha256 = "0z8jw4s3kmaq1lcac12rj9yhcgi4nmkbskplm1xdcq7k7mffjqa0";
    };
  };
  "show-build-parameters-1.0" = mkJenkinsPlugin {
    name = "show-build-parameters-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/show-build-parameters/1.0/show-build-parameters.hpi";
      sha256 = "1gbjwfq9msn15q85mdzga6b3w4g9hs3rkcgwh3kdpq1ip6m0mv1j";
    };
  };
  "sicci_for_xcode-0.0.8" = mkJenkinsPlugin {
    name = "sicci_for_xcode-0.0.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/sicci_for_xcode/0.0.8/sicci_for_xcode.hpi";
      sha256 = "1diyr81hw9b4ca1p9qgz8ya2wkpl7izjimdqq61ij1jacp0fcaal";
    };
  };
  "sidebar-link-1.7" = mkJenkinsPlugin {
    name = "sidebar-link-1.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/sidebar-link/1.7/sidebar-link.hpi";
      sha256 = "0l86qzcxwaqxw1h1nwkrwxxzk38dpvc3af0kbw3plzmz3cz9lmkh";
    };
  };
  "sidebar-update-notification-1.1.0" = mkJenkinsPlugin {
    name = "sidebar-update-notification-1.1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/sidebar-update-notification/1.1.0/sidebar-update-notification.hpi";
      sha256 = "0ydrh2mx6zah6dqvkz69cik45z4mfwv0gxskz1qm8lp6nwrs4zj5";
    };
  };
  "signal-killer-1.0" = mkJenkinsPlugin {
    name = "signal-killer-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/signal-killer/1.0/signal-killer.hpi";
      sha256 = "0qb99mw5hpj3pr5b8gcq8wkby2walciidxnddy8slglmsa8ilqmi";
    };
  };
  "silk-performer-plugin-1.0.5" = mkJenkinsPlugin {
    name = "silk-performer-plugin-1.0.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/silk-performer-plugin/1.0.5/silk-performer-plugin.hpi";
      sha256 = "0nmz650ymk75isysc78gcc9pn5f4i1iin6dangr0yiw2n2xgvldy";
    };
  };
  "simple-parameterized-builds-report-1.4" = mkJenkinsPlugin {
    name = "simple-parameterized-builds-report-1.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/simple-parameterized-builds-report/1.4/simple-parameterized-builds-report.hpi";
      sha256 = "0k6pc4rgrs79s9xsllgnzncr3mwdj57xn29gwxxjarnd4aqcswp7";
    };
  };
  "simple-theme-plugin-0.3" = mkJenkinsPlugin {
    name = "simple-theme-plugin-0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/simple-theme-plugin/0.3/simple-theme-plugin.hpi";
      sha256 = "0d0qjs792g60c5zbkr94c2629mpwyql6x5rp9156hs8mnlgqdzd5";
    };
  };
  "simpleclearcase-1.2.2" = mkJenkinsPlugin {
    name = "simpleclearcase-1.2.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/simpleclearcase/1.2.2/simpleclearcase.hpi";
      sha256 = "19mpmsmrb7i65ap181lj9y9srbq07l72nbfndfps5ca2h0hax0xq";
    };
  };
  "simpleupdatesite-1.1.2" = mkJenkinsPlugin {
    name = "simpleupdatesite-1.1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/simpleupdatesite/1.1.2/simpleupdatesite.hpi";
      sha256 = "046x2hgbv81ky0xzss1v0p5si4gsxaj3anay56zpc6azyh3x0mrz";
    };
  };
  "singleuseslave-1.0.0" = mkJenkinsPlugin {
    name = "singleuseslave-1.0.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/singleuseslave/1.0.0/singleuseslave.hpi";
      sha256 = "0zpn9hnvyw0clgq4zppn86hg2wvhn3qgsvbgqyjqhyycgw1b1h1r";
    };
  };
  "sitemonitor-0.5" = mkJenkinsPlugin {
    name = "sitemonitor-0.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/sitemonitor/0.5/sitemonitor.hpi";
      sha256 = "0sq0jkayr4j9ghbdd182sdafmrhw5cxajnhlxaw0lhbycm8kbdsi";
    };
  };
  "skip-certificate-check-1.0" = mkJenkinsPlugin {
    name = "skip-certificate-check-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/skip-certificate-check/1.0/skip-certificate-check.hpi";
      sha256 = "0hp1dv7cppx4n7sqxjlh2vswp8wjq9xsb37lfw7w06d6f3mfxigb";
    };
  };
  "skype-notifier-1.1.0" = mkJenkinsPlugin {
    name = "skype-notifier-1.1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/skype-notifier/1.1.0/skype-notifier.hpi";
      sha256 = "0i2k0s06cilspl5rm2l1hh2smd82jaw7s0716diwwrianfplg7ns";
    };
  };
  "skytap-2.02" = mkJenkinsPlugin {
    name = "skytap-2.02";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/skytap/2.02/skytap.hpi";
      sha256 = "03xrma5d27x3jjlcw0mr7bisrgdsr35nsmfzkyv2aw4qq29mnnk9";
    };
  };
  "slack-1.8.1" = mkJenkinsPlugin {
    name = "slack-1.8.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/slack/1.8.1/slack.hpi";
      sha256 = "1bbpb4q0rvxs49d3d3pw2wndjjrsxqx1arminn7dvmz9d496c5fg";
    };
  };
  "sladiator-notifier-1.0.4" = mkJenkinsPlugin {
    name = "sladiator-notifier-1.0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/sladiator-notifier/1.0.4/sladiator-notifier.hpi";
      sha256 = "1rm5wlpylls0p0gp94c9wajgrpikxsdc69czci58rw1hac346vr4";
    };
  };
  "slave-prerequisites-1.0" = mkJenkinsPlugin {
    name = "slave-prerequisites-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/slave-prerequisites/1.0/slave-prerequisites.hpi";
      sha256 = "08qqm7dwbxds607bkf1l0xn94ks5qawkyf57n2vb1r65krckc9ys";
    };
  };
  "slave-proxy-1.1" = mkJenkinsPlugin {
    name = "slave-proxy-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/slave-proxy/1.1/slave-proxy.hpi";
      sha256 = "0y9iwm20djwgvvmq18z5sxn9w7psi8hmxr86byph6j9002svigxs";
    };
  };
  "slave-setup-1.9" = mkJenkinsPlugin {
    name = "slave-setup-1.9";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/slave-setup/1.9/slave-setup.hpi";
      sha256 = "12lbg9ival6vj1n19x76ya60013zc5sfbrbch3das0n8ana0g8if";
    };
  };
  "slave-squatter-1.2" = mkJenkinsPlugin {
    name = "slave-squatter-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/slave-squatter/1.2/slave-squatter.hpi";
      sha256 = "1r4a83vyw5ypkpxhih6188ci0n6wjx2cvgyg1vqxrkm1missw3hj";
    };
  };
  "slave-status-1.6" = mkJenkinsPlugin {
    name = "slave-status-1.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/slave-status/1.6/slave-status.hpi";
      sha256 = "0v1mznihvgc3vw8d545anziaxz4aa0bxyq9hizivdmhnmwirxcck";
    };
  };
  "slave-utilization-plugin-1.8" = mkJenkinsPlugin {
    name = "slave-utilization-plugin-1.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/slave-utilization-plugin/1.8/slave-utilization-plugin.hpi";
      sha256 = "1wb3rk5h20ddaakmgn97v34g3w0yh4d7hgkspxk1cg4gyn94qhy2";
    };
  };
  "sloccount-1.21" = mkJenkinsPlugin {
    name = "sloccount-1.21";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/sloccount/1.21/sloccount.hpi";
      sha256 = "085lam55pyygk2nr4x1q2bqb7g4c7p84a9m15kb4z6y8jd3pwzhs";
    };
  };
  "smart-jenkins-1.0" = mkJenkinsPlugin {
    name = "smart-jenkins-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/smart-jenkins/1.0/smart-jenkins.hpi";
      sha256 = "1w07dqgdbfcahp7zyhxqn80hc5lhbv3snrz4s31hvb4p5vc2q878";
    };
  };
  "smartfrog-plugin-2.2.4" = mkJenkinsPlugin {
    name = "smartfrog-plugin-2.2.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/smartfrog-plugin/2.2.4/smartfrog-plugin.hpi";
      sha256 = "1ww88bh4ac67q422dz3b3i4lx467bgb7rhw7m6737xy81n42hsh4";
    };
  };
  "sms-1.2" = mkJenkinsPlugin {
    name = "sms-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/sms/1.2/sms.hpi";
      sha256 = "15lg8dg120aks692i7kbfnq4r9ckjl6jvl8p1s988vpshgv6id84";
    };
  };
  "snsnotify-1.12" = mkJenkinsPlugin {
    name = "snsnotify-1.12";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/snsnotify/1.12/snsnotify.hpi";
      sha256 = "1z3pyvmsmmzawhngyshddpzsmwgxxalmx5lkly4lp69hv9gxj33p";
    };
  };
  "sonar-gerrit-1.0.6" = mkJenkinsPlugin {
    name = "sonar-gerrit-1.0.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/sonar-gerrit/1.0.6/sonar-gerrit.hpi";
      sha256 = "1h3rw1ic1wqn6fwak3iscai97shlxzxqggjy7vvxwbcsxnd845x9";
    };
  };
  "sonar-2.3" = mkJenkinsPlugin {
    name = "sonar-2.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/sonar/2.3/sonar.hpi";
      sha256 = "0xcf494mw7mr9mrr3j008g7j5ik7rdzxxqa7kagkhyzl1y3m97b7";
    };
  };
  "sonargraph-plugin-1.6.4" = mkJenkinsPlugin {
    name = "sonargraph-plugin-1.6.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/sonargraph-plugin/1.6.4/sonargraph-plugin.hpi";
      sha256 = "1a72m6772lc55z1gp26r7h9avrjrrprawzrq90asadv2g6y8j4c1";
    };
  };
  "sounds-0.4.3" = mkJenkinsPlugin {
    name = "sounds-0.4.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/sounds/0.4.3/sounds.hpi";
      sha256 = "05hc2yqg0asa006dxfzfph8vdh5dywr35b36r8ikqc4y4xxrmdf5";
    };
  };
  "speaks-0.1.1" = mkJenkinsPlugin {
    name = "speaks-0.1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/speaks/0.1.1/speaks.hpi";
      sha256 = "0q0bdrik9davjggd79ch8w0lbb760khqkpbng126278nkpn7cjzz";
    };
  };
  "spoonscript-1.2" = mkJenkinsPlugin {
    name = "spoonscript-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/spoonscript/1.2/spoonscript.hpi";
      sha256 = "0layffvslhg5v5xzd1rp4j1l1y3sab59z3ws2pfdl011xwjp5nab";
    };
  };
  "sqlplus-script-runner-1.0.2" = mkJenkinsPlugin {
    name = "sqlplus-script-runner-1.0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/sqlplus-script-runner/1.0.2/sqlplus-script-runner.hpi";
      sha256 = "0iy2443dhv5ck6y3yqy1prfybn8xkxwnya941c1nmfvwh1ig8v4w";
    };
  };
  "sra-deploy-1.4.2.4" = mkJenkinsPlugin {
    name = "sra-deploy-1.4.2.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/sra-deploy/1.4.2.4/sra-deploy.hpi";
      sha256 = "09qpw0w6sfa2dcszi159wxmy2shb9lqywsfrc4iy83wv8iiddr5b";
    };
  };
  "ssh-agent-1.9" = mkJenkinsPlugin {
    name = "ssh-agent-1.9";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ssh-agent/1.9/ssh-agent.hpi";
      sha256 = "1p5linjfap3k9i2nq7j90nv8mwbv9h2r76c6p45yqnddaql2wyg2";
    };
  };
  "ssh-credentials-1.11" = mkJenkinsPlugin {
    name = "ssh-credentials-1.11";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ssh-credentials/1.11/ssh-credentials.hpi";
      sha256 = "065b9sz4njw15m7x0mqdyms721rnrkbpkr2a2s04syb206pkc3z8";
    };
  };
  "ssh-slaves-1.10" = mkJenkinsPlugin {
    name = "ssh-slaves-1.10";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ssh-slaves/1.10/ssh-slaves.hpi";
      sha256 = "1s96kfg5z44p4i318amp96072wc1vkfi0bswmjzmcz1436l5h2aw";
    };
  };
  "ssh-2.4" = mkJenkinsPlugin {
    name = "ssh-2.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ssh/2.4/ssh.hpi";
      sha256 = "1np656hjyl7nfba2d2aqsgg0rb795ql5i9zvb8nry01h751jsv14";
    };
  };
  "ssh2easy-1.3" = mkJenkinsPlugin {
    name = "ssh2easy-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ssh2easy/1.3/ssh2easy.hpi";
      sha256 = "1jjsd6rja368vm6azxflv8q7256vvm45h1hy5x56mx1cgxbb01qa";
    };
  };
  "stackhammer-1.0.6" = mkJenkinsPlugin {
    name = "stackhammer-1.0.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/stackhammer/1.0.6/stackhammer.hpi";
      sha256 = "1h7nrgx0wqa5jraq1awkh5vxhdlwjq0cpbyl5jkpi1pgb2s6h8wm";
    };
  };
  "staf-0.1" = mkJenkinsPlugin {
    name = "staf-0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/staf/0.1/staf.hpi";
      sha256 = "0wx7fsplcw5jpl5lca9jkx824l8qbknwpy5c6s3ddsmiz7yrz2qb";
    };
  };
  "starteam-0.6.13" = mkJenkinsPlugin {
    name = "starteam-0.6.13";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/starteam/0.6.13/starteam.hpi";
      sha256 = "1lw6r04vp0n2mnd9j5wpv8afcnfxnadxh56axj8g0fxwz8bc11g0";
    };
  };
  "started-by-envvar-1.0" = mkJenkinsPlugin {
    name = "started-by-envvar-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/started-by-envvar/1.0/started-by-envvar.hpi";
      sha256 = "1bb6lvm469602ms9ds6bal33a69br57v4rg2nhnzbxzxvrjs7f99";
    };
  };
  "startup-trigger-plugin-2.5" = mkJenkinsPlugin {
    name = "startup-trigger-plugin-2.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/startup-trigger-plugin/2.5/startup-trigger-plugin.hpi";
      sha256 = "0lpy4zm1z6chjzr64l36krmf5dzzbalg7n9zh18lyv60h8fjaaxf";
    };
  };
  "stash-pullrequest-builder-1.5.2" = mkJenkinsPlugin {
    name = "stash-pullrequest-builder-1.5.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/stash-pullrequest-builder/1.5.2/stash-pullrequest-builder.hpi";
      sha256 = "10rhsi6a6rz2pjj14l2y50nqd6i4308njxh5jzhkni5m6hifvfhx";
    };
  };
  "stashNotifier-1.10.2" = mkJenkinsPlugin {
    name = "stashNotifier-1.10.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/stashNotifier/1.10.2/stashNotifier.hpi";
      sha256 = "0ihizizm6z7m174ajg8grw0mydjkbsy6rb2wm25375f9l18j9h7k";
    };
  };
  "status-view-1.0" = mkJenkinsPlugin {
    name = "status-view-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/status-view/1.0/status-view.hpi";
      sha256 = "12fafr86b8yk7ylsmy22vwqn76c30jvh3xllcf4ln9pwc788ggn9";
    };
  };
  "statusmonitor-1.3" = mkJenkinsPlugin {
    name = "statusmonitor-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/statusmonitor/1.3/statusmonitor.hpi";
      sha256 = "175g6k9yy6kll46wxx3bi7pjhsccwd7f21ird4b01zk1gnj2zm3h";
    };
  };
  "stepcounter-1.3.2" = mkJenkinsPlugin {
    name = "stepcounter-1.3.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/stepcounter/1.3.2/stepcounter.hpi";
      sha256 = "0pclx87gn6lh42ld527w52f6lpffixfjdffnrmn61zncz68barzv";
    };
  };
  "storable-configs-plugin-1.0" = mkJenkinsPlugin {
    name = "storable-configs-plugin-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/storable-configs-plugin/1.0/storable-configs-plugin.hpi";
      sha256 = "0p8zwkpyln5rpl6480mmplvikm0q1nhfmgccgvma1x03a2l1p7bn";
    };
  };
  "strawboss-1.3" = mkJenkinsPlugin {
    name = "strawboss-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/strawboss/1.3/strawboss.hpi";
      sha256 = "0xrvn510xb850wcnb2508q1mywn2h56wm5l8hz0kw28azyqvdmas";
    };
  };
  "subversion-2.5.7" = mkJenkinsPlugin {
    name = "subversion-2.5.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/subversion/2.5.7/subversion.hpi";
      sha256 = "1cpb86iiywp3jp0m86ghzw6bnz8xm05b5ydk515kp0k1h3bm1gpd";
    };
  };
  "summary_report-1.14" = mkJenkinsPlugin {
    name = "summary_report-1.14";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/summary_report/1.14/summary_report.hpi";
      sha256 = "0s24yjxfk3nv9pml32kf3gz8ss8mhyfa5s60ch3bn0ipa551ia0p";
    };
  };
  "sumologic-publisher-1.1" = mkJenkinsPlugin {
    name = "sumologic-publisher-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/sumologic-publisher/1.1/sumologic-publisher.hpi";
      sha256 = "05zy68002cdsdpx5kk67yg3d66agizlv1f2aklhb2r984nlsk4wf";
    };
  };
  "support-core-2.30" = mkJenkinsPlugin {
    name = "support-core-2.30";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/support-core/2.30/support-core.hpi";
      sha256 = "1r1gxs2j578w087c49i6i3dnk8rmghr592zwsfxdh81lxcqa9774";
    };
  };
  "suppress-stack-trace-1.4" = mkJenkinsPlugin {
    name = "suppress-stack-trace-1.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/suppress-stack-trace/1.4/suppress-stack-trace.hpi";
      sha256 = "1p9m72406ir5xvgbc07fihjbhsckn69vf5spa52d4pyhidql2bv7";
    };
  };
  "svn-release-mgr-1.2" = mkJenkinsPlugin {
    name = "svn-release-mgr-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/svn-release-mgr/1.2/svn-release-mgr.hpi";
      sha256 = "03hfjq04riadr744cjmfycbgbckyjkpvmpjzsarxzalxyjlljkn8";
    };
  };
  "svn-revert-plugin-1.3" = mkJenkinsPlugin {
    name = "svn-revert-plugin-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/svn-revert-plugin/1.3/svn-revert-plugin.hpi";
      sha256 = "18ljr6m08zrycp96af5fri6zd48iyypcdamqkiyvzyz4j288y9xw";
    };
  };
  "svn-tag-1.18" = mkJenkinsPlugin {
    name = "svn-tag-1.18";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/svn-tag/1.18/svn-tag.hpi";
      sha256 = "19wcp6sdhsbqx5svj0pwy3khmzbzbj10w0rarq4ifjg613y4q5mh";
    };
  };
  "svn-workspace-cleaner-1.1" = mkJenkinsPlugin {
    name = "svn-workspace-cleaner-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/svn-workspace-cleaner/1.1/svn-workspace-cleaner.hpi";
      sha256 = "0wx4zcql33j2mynlikk9511ardbzihwa0liazq4wmhfc9hyk7hz5";
    };
  };
  "svncompat13-1.2" = mkJenkinsPlugin {
    name = "svncompat13-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/svncompat13/1.2/svncompat13.hpi";
      sha256 = "19afmwqj3v9lxddgngzyk6lhn2afbxxqzqls2bnzijq42mr9j8rm";
    };
  };
  "svncompat14-1.1" = mkJenkinsPlugin {
    name = "svncompat14-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/svncompat14/1.1/svncompat14.hpi";
      sha256 = "1dydd3v591r2mdn3cybhy9ai8jjxids0m7086nnc4rdxd39ainr9";
    };
  };
  "svnmerge-2.6" = mkJenkinsPlugin {
    name = "svnmerge-2.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/svnmerge/2.6/svnmerge.hpi";
      sha256 = "02c17xnmaw22khkr7x40icg7wqhnzf8dnfijk6kpwdx8i1rijlcz";
    };
  };
  "svnpublisher-0.1" = mkJenkinsPlugin {
    name = "svnpublisher-0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/svnpublisher/0.1/svnpublisher.hpi";
      sha256 = "1jd220dfz34sannan6xmjp5wxllw1dj82qmr5ysmlx178n79sbf9";
    };
  };
  "swarm-2.0" = mkJenkinsPlugin {
    name = "swarm-2.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/swarm/2.0/swarm.hpi";
      sha256 = "1id93jj5mlv6gz4zwx4pdh2f8ccl5rlxv5jzfs2i3vb6b0raabqn";
    };
  };
  "synergy-1.7" = mkJenkinsPlugin {
    name = "synergy-1.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/synergy/1.7/synergy.hpi";
      sha256 = "07i8689laxn9cylbi8mp8hjcmr16s8a1qdp3vsm1bnvw69jpxz43";
    };
  };
  "syslog-logger-1.0.5" = mkJenkinsPlugin {
    name = "syslog-logger-1.0.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/syslog-logger/1.0.5/syslog-logger.hpi";
      sha256 = "18a97ndsmn0xybbibw83mb1hx917adq6ncpvd5idp8nnvr8dgy8l";
    };
  };
  "systemloadaverage-monitor-1.2" = mkJenkinsPlugin {
    name = "systemloadaverage-monitor-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/systemloadaverage-monitor/1.2/systemloadaverage-monitor.hpi";
      sha256 = "0cg5k3qpqcjg6ny9wj0f7jgz5wacykk5vm7l6w8q9zmka292g47s";
    };
  };
  "tag-profiler-0.2" = mkJenkinsPlugin {
    name = "tag-profiler-0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/tag-profiler/0.2/tag-profiler.hpi";
      sha256 = "1gc13pd2hi9f3qzzdma51brhcay9cq6ymnak9ncqcysm4pzq2r8s";
    };
  };
  "tap-1.24" = mkJenkinsPlugin {
    name = "tap-1.24";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/tap/1.24/tap.hpi";
      sha256 = "1bxmcjiwxc7v6kmd3vgzi5zhz7hxhcp2r24mjck4w7bk09q2p949";
    };
  };
  "tasks-4.47" = mkJenkinsPlugin {
    name = "tasks-4.47";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/tasks/4.47/tasks.hpi";
      sha256 = "035wpicnz1jr3fssgaba330bl407ryf1qdws579y4rki4i7j4m3k";
    };
  };
  "tattletale-plugin-0.3" = mkJenkinsPlugin {
    name = "tattletale-plugin-0.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/tattletale-plugin/0.3/tattletale-plugin.hpi";
      sha256 = "0rl0rvh73zg0cjxy7hdbj06vspi3imv5jx8xdz5jwxwvf1wr5abm";
    };
  };
  "tcl-0.4" = mkJenkinsPlugin {
    name = "tcl-0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/tcl/0.4/tcl.hpi";
      sha256 = "0wx6lhhxb46kya1wzivv5klj67plma3b2n2jlrx1qs3fbi761300";
    };
  };
  "team-views-0.9.0" = mkJenkinsPlugin {
    name = "team-views-0.9.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/team-views/0.9.0/team-views.hpi";
      sha256 = "10w4n88y1jw8n1d74gi3riglbj5slq41dynzxvnx0rq4pv7fbily";
    };
  };
  "teamconcert-git-1.0.10" = mkJenkinsPlugin {
    name = "teamconcert-git-1.0.10";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/teamconcert-git/1.0.10/teamconcert-git.hpi";
      sha256 = "0qblx32jf3jcc67rwcjm98vacdb7qs0rznsvj3z7jlzfpb6dsz45";
    };
  };
  "teamconcert-1.1.9.9" = mkJenkinsPlugin {
    name = "teamconcert-1.1.9.9";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/teamconcert/1.1.9.9/teamconcert.hpi";
      sha256 = "0vcwsvg5w1mrgv48mj3qcw43sd7v3x27jdxa6zbybjbvy6lcd38r";
    };
  };
  "template-project-1.5.1" = mkJenkinsPlugin {
    name = "template-project-1.5.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/template-project/1.5.1/template-project.hpi";
      sha256 = "0zjy2faphyc6h6ibqns8b8wmmsjg6qhm3r2g894raz6fwxnal393";
    };
  };
  "template-workflows-1.2" = mkJenkinsPlugin {
    name = "template-workflows-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/template-workflows/1.2/template-workflows.hpi";
      sha256 = "0v927z6znkylfj05ahnnx0nqjkj1jw50ay3lm29d082f5859kqcs";
    };
  };
  "terminal-1.4" = mkJenkinsPlugin {
    name = "terminal-1.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/terminal/1.4/terminal.hpi";
      sha256 = "132pi92w1qsrwmcwv09i9qfr17s7zb643hjlmslzy66c9xx10h7m";
    };
  };
  "terminate-ssh-processes-plugin-1.0" = mkJenkinsPlugin {
    name = "terminate-ssh-processes-plugin-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/terminate-ssh-processes-plugin/1.0/terminate-ssh-processes-plugin.hpi";
      sha256 = "1gvchi516cbl1rb2l83jrk4s4krvl1s4jn0fppb06ff843qkz4gg";
    };
  };
  "terraform-1.0.1" = mkJenkinsPlugin {
    name = "terraform-1.0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/terraform/1.0.1/terraform.hpi";
      sha256 = "0fnh7v5qn6zf6m4k6g4k0q9rg7m6gylb2kfnaw9rnfnrxfr643s1";
    };
  };
  "test-results-analyzer-0.3.2" = mkJenkinsPlugin {
    name = "test-results-analyzer-0.3.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/test-results-analyzer/0.3.2/test-results-analyzer.hpi";
      sha256 = "1dafdn4sql0gpsig0w6fcjfwsfnh6zy27b7aix3liq21jdgwsz9y";
    };
  };
  "test-stability-1.0" = mkJenkinsPlugin {
    name = "test-stability-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/test-stability/1.0/test-stability.hpi";
      sha256 = "0083s4xbg05bahpy5vm19jzhkzmkiizv78ysfhdmhvnm3czb7a24";
    };
  };
  "testInProgress-1.4" = mkJenkinsPlugin {
    name = "testInProgress-1.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/testInProgress/1.4/testInProgress.hpi";
      sha256 = "1mhdcx7qy2fm80r5wgsjzgwc9m1i109ja18nm8fibwj2krxigy8k";
    };
  };
  "testabilityexplorer-0.4" = mkJenkinsPlugin {
    name = "testabilityexplorer-0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/testabilityexplorer/0.4/testabilityexplorer.hpi";
      sha256 = "0y443lsprgmj78wpb0223ikqn8zv50czi11dsqs43xax90b181l0";
    };
  };
  "testcomplete-xunit-1.1" = mkJenkinsPlugin {
    name = "testcomplete-xunit-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/testcomplete-xunit/1.1/testcomplete-xunit.hpi";
      sha256 = "0x2xi8r8lisnr2s7nbd0919fr7akdzbxrpb9iql7kdaaizcs9jrs";
    };
  };
  "testingbot-1.12" = mkJenkinsPlugin {
    name = "testingbot-1.12";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/testingbot/1.12/testingbot.hpi";
      sha256 = "19a0jy100fal5c7hlmc0bnqqlhdp09ccrdhzr9l248h6s5677mly";
    };
  };
  "testlink-3.11" = mkJenkinsPlugin {
    name = "testlink-3.11";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/testlink/3.11/testlink.hpi";
      sha256 = "15wjg63nizxlqqmhhcxl608hnixirrhjf0g1a533rkc801b2k1v9";
    };
  };
  "testng-plugin-1.10" = mkJenkinsPlugin {
    name = "testng-plugin-1.10";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/testng-plugin/1.10/testng-plugin.hpi";
      sha256 = "1d5k7j9smbnirmvs1wmgncvci5p8s9lbf5858kadzvqv9wdshdpx";
    };
  };
  "testopia-1.3" = mkJenkinsPlugin {
    name = "testopia-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/testopia/1.3/testopia.hpi";
      sha256 = "1x7jwqfbgv6kpkv2zxrw0scavp1qs2dwgdy9mrnrc2v6vw0yqw5s";
    };
  };
  "text-file-operations-1.2.1" = mkJenkinsPlugin {
    name = "text-file-operations-1.2.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/text-file-operations/1.2.1/text-file-operations.hpi";
      sha256 = "0zgki6x70c3qvnf9bfvzw86pyjvpci9agxcr9rh91mvmnk11z9x4";
    };
  };
  "text-finder-run-condition-0.1" = mkJenkinsPlugin {
    name = "text-finder-run-condition-0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/text-finder-run-condition/0.1/text-finder-run-condition.hpi";
      sha256 = "0bxx6fyj7wczxcz08v4lqspn7k278dklblad11g84mkpk9adchxv";
    };
  };
  "text-finder-1.10" = mkJenkinsPlugin {
    name = "text-finder-1.10";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/text-finder/1.10/text-finder.hpi";
      sha256 = "17biqrdl6gjh0nqiblgiknikhldixs7r07fc1409dmnzd2yc5b10";
    };
  };
  "tfs-4.0.0" = mkJenkinsPlugin {
    name = "tfs-4.0.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/tfs/4.0.0/tfs.hpi";
      sha256 = "14wqhssx2j6qdpxmx5gk3r79m7ylnlr7hpczqpwlr9jcn7kc42ix";
    };
  };
  "thinBackup-1.7.4" = mkJenkinsPlugin {
    name = "thinBackup-1.7.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/thinBackup/1.7.4/thinBackup.hpi";
      sha256 = "0r36clmb7q9yz3k1kbff30kpccpfgrbabjy19f4gh6g3xvsx3262";
    };
  };
  "thread-dump-action-plugin-1.0" = mkJenkinsPlugin {
    name = "thread-dump-action-plugin-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/thread-dump-action-plugin/1.0/thread-dump-action-plugin.hpi";
      sha256 = "14c5ayn5v83l0liz53phz5iv870cp60clgcksk757xq5f09sjr9i";
    };
  };
  "threadfix-1.5.2" = mkJenkinsPlugin {
    name = "threadfix-1.5.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/threadfix/1.5.2/threadfix.hpi";
      sha256 = "1jgsjns4zrq3qijd0kfldywvkgwmv459akx7112ggwcp5g4aiqcn";
    };
  };
  "throttle-concurrents-1.8.4" = mkJenkinsPlugin {
    name = "throttle-concurrents-1.8.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/throttle-concurrents/1.8.4/throttle-concurrents.hpi";
      sha256 = "1vlc2q7rc6z285qapv96ibsak2d74s82vsjgcsn6gb277k16bld7";
    };
  };
  "thucydides-0.1" = mkJenkinsPlugin {
    name = "thucydides-0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/thucydides/0.1/thucydides.hpi";
      sha256 = "18hcr4rwcx642bhqwmclx9q44wiczgl7pdspbaj86yv5mv0y8p8p";
    };
  };
  "tibco-builder-1.4" = mkJenkinsPlugin {
    name = "tibco-builder-1.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/tibco-builder/1.4/tibco-builder.hpi";
      sha256 = "005bcgdvifsc9xcwwv7zv3l8nz8x1a0rf5p1sli4h42jgc8hx1sg";
    };
  };
  "timestamper-1.7.4" = mkJenkinsPlugin {
    name = "timestamper-1.7.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/timestamper/1.7.4/timestamper.hpi";
      sha256 = "1aia21jr8w6kwlrib8xji92g3v3d2xmrrmfcnad97mpw4hf33dsj";
    };
  };
  "tinfoil-scan-1.3" = mkJenkinsPlugin {
    name = "tinfoil-scan-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/tinfoil-scan/1.3/tinfoil-scan.hpi";
      sha256 = "1d2r9i88dk6dyfm75lrn1xdjk5f3lj7bq1gwwdxlgrjjl9p5ba9g";
    };
  };
  "tmpcleaner-1.2" = mkJenkinsPlugin {
    name = "tmpcleaner-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/tmpcleaner/1.2/tmpcleaner.hpi";
      sha256 = "1l4rcckin5plp65h2jr6rvk8rv9ss8v0s6yx703f081mh3bvvq36";
    };
  };
  "token-macro-1.12.1" = mkJenkinsPlugin {
    name = "token-macro-1.12.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/token-macro/1.12.1/token-macro.hpi";
      sha256 = "126nhwzdm57wvgym6s0h1pwi16i1nx2k2y1klxwlqrp8ywhcrmps";
    };
  };
  "tool-labels-plugin-3.0" = mkJenkinsPlugin {
    name = "tool-labels-plugin-3.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/tool-labels-plugin/3.0/tool-labels-plugin.hpi";
      sha256 = "0nfr06dbr2ijgjw0r3apmy4sy32wkn9jwn6ych5z53n8rkj4sk8n";
    };
  };
  "toolenv-1.1" = mkJenkinsPlugin {
    name = "toolenv-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/toolenv/1.1/toolenv.hpi";
      sha256 = "1q9kg78v2pa0fx7zna17si1c2w7m5j45hgvswyx3bbqzxqyp66fd";
    };
  };
  "trac-publisher-plugin-1.3" = mkJenkinsPlugin {
    name = "trac-publisher-plugin-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/trac-publisher-plugin/1.3/trac-publisher-plugin.hpi";
      sha256 = "1igd9mdacqq5jc6xdnphl0bjbsxjjdfg5h8v12najlmcmf45dnnl";
    };
  };
  "trac-1.13" = mkJenkinsPlugin {
    name = "trac-1.13";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/trac/1.13/trac.hpi";
      sha256 = "19jcvz36i3dlk1z7dd9yphc1sas1r2hw408qlahi74s4k0piqkxc";
    };
  };
  "tracking-git-1.0" = mkJenkinsPlugin {
    name = "tracking-git-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/tracking-git/1.0/tracking-git.hpi";
      sha256 = "185mxb92f43jx4fw2yayfrr947gz9dvibs34ccz1yag7b0prcg2i";
    };
  };
  "tracking-svn-1.1" = mkJenkinsPlugin {
    name = "tracking-svn-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/tracking-svn/1.1/tracking-svn.hpi";
      sha256 = "0iwp1kckvxq1h777wrnrcni6axdp4kavhmgdl7b3p4a6wr649hlp";
    };
  };
  "transifex-0.1.0" = mkJenkinsPlugin {
    name = "transifex-0.1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/transifex/0.1.0/transifex.hpi";
      sha256 = "0789zbnrwjbx17q56f8j7z2223p8rhvlfc0j98rxnfj0gxlhxk3g";
    };
  };
  "translation-1.12" = mkJenkinsPlugin {
    name = "translation-1.12";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/translation/1.12/translation.hpi";
      sha256 = "000mhhvxqiyrsdjkillqzpr3vc4m93zibbxxm3f78mxffv9b6c06";
    };
  };
  "travis-yml-0.1.0" = mkJenkinsPlugin {
    name = "travis-yml-0.1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/travis-yml/0.1.0/travis-yml.hpi";
      sha256 = "00g6zhi7x2mbb4i6bjs8srxky8hhmalnm8lb177kbid3k81k1jga";
    };
  };
  "tuxdroid-1.7" = mkJenkinsPlugin {
    name = "tuxdroid-1.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/tuxdroid/1.7/tuxdroid.hpi";
      sha256 = "1w9lxjf3nwcrmqzqssya8n86aj0qq1kl8667knri22c25jpg3fw6";
    };
  };
  "twitter-0.7" = mkJenkinsPlugin {
    name = "twitter-0.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/twitter/0.7/twitter.hpi";
      sha256 = "1zk9gklbqpg88jdlvcwzg17gyggzx1skzy10kvzvb0839g1328bw";
    };
  };
  "typetalk-1.1.0" = mkJenkinsPlugin {
    name = "typetalk-1.1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/typetalk/1.1.0/typetalk.hpi";
      sha256 = "143qdbd7rslxxxr9g7jwpzxvz7lqfnpnzii9lwp91dczn9xpg0py";
    };
  };
  "ui-samples-plugin-2.0" = mkJenkinsPlugin {
    name = "ui-samples-plugin-2.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ui-samples-plugin/2.0/ui-samples-plugin.hpi";
      sha256 = "0c5lj3c30s8p44c9izmnzpv2bybkv1r5gjv4s6x2aa36xclb2xii";
    };
  };
  "ui-test-capture-1.0.41" = mkJenkinsPlugin {
    name = "ui-test-capture-1.0.41";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ui-test-capture/1.0.41/ui-test-capture.hpi";
      sha256 = "1g4anajjk93jv3z1yi5zkrdqdqwzvh7sq03h69kizblgkg4z2p1h";
    };
  };
  "unicorn-0.1.1" = mkJenkinsPlugin {
    name = "unicorn-0.1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/unicorn/0.1.1/unicorn.hpi";
      sha256 = "0x3icnfcpa8v5zhhmdr49f0wp828iiwhgqyh81r9rvqa73a294im";
    };
  };
  "unique-id-2.1.1" = mkJenkinsPlugin {
    name = "unique-id-2.1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/unique-id/2.1.1/unique-id.hpi";
      sha256 = "0hymdcsvqsp352rk8gg832cfw7aqg6672g0nk29n82a6z9pdb859";
    };
  };
  "unity-asset-server-1.1.1" = mkJenkinsPlugin {
    name = "unity-asset-server-1.1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/unity-asset-server/1.1.1/unity-asset-server.hpi";
      sha256 = "19k0x2scdr268ag4q8w8k9vhxx0mc00sj4icivkz73riqgp662q7";
    };
  };
  "unity3d-plugin-1.3" = mkJenkinsPlugin {
    name = "unity3d-plugin-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/unity3d-plugin/1.3/unity3d-plugin.hpi";
      sha256 = "00b24sjzdhbjqhp4hzg7arlj1mw9bcj4m4q320151446hyj3vczf";
    };
  };
  "uno-choice-1.3" = mkJenkinsPlugin {
    name = "uno-choice-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/uno-choice/1.3/uno-choice.hpi";
      sha256 = "1p0n3vdxw5x1c7l128rwayawp0wpvv6cd0n9l6pb9gnza3kfq0lc";
    };
  };
  "unreliable-slave-plugin-1.2" = mkJenkinsPlugin {
    name = "unreliable-slave-plugin-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/unreliable-slave-plugin/1.2/unreliable-slave-plugin.hpi";
      sha256 = "14r8brvzavl5gglawdj3pbm6b44hz6hiiiiay5dncgyp3jmb2ci4";
    };
  };
  "update-sites-manager-1.0.1" = mkJenkinsPlugin {
    name = "update-sites-manager-1.0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/update-sites-manager/1.0.1/update-sites-manager.hpi";
      sha256 = "0dnpkjcxm5xvxj6y86ccn4m4bbyf081b025m0c3mk45rn2r0h1lb";
    };
  };
  "upstream-downstream-view-1.006" = mkJenkinsPlugin {
    name = "upstream-downstream-view-1.006";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/upstream-downstream-view/1.006/upstream-downstream-view.hpi";
      sha256 = "1a3gznwbv3zsdz8zai7cwcfip65bylyiqbdil64891cmvc8hda6j";
    };
  };
  "uptime-1.0" = mkJenkinsPlugin {
    name = "uptime-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/uptime/1.0/uptime.hpi";
      sha256 = "1lfqggi2ajvhhywgmn5i130wziwhg2sapc01wsg46ni2j1r4wv9q";
    };
  };
  "urltrigger-0.41" = mkJenkinsPlugin {
    name = "urltrigger-0.41";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/urltrigger/0.41/urltrigger.hpi";
      sha256 = "103ckmm7fiwkr184y0gwx7myhdbqii6fz1fhy34wshr8lya4l8ys";
    };
  };
  "utplsql-0.6.1" = mkJenkinsPlugin {
    name = "utplsql-0.6.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/utplsql/0.6.1/utplsql.hpi";
      sha256 = "09fzkfc9sm2hkj07xpgarza8rm69fq1hshd38jdp5rzyy0azm1l2";
    };
  };
  "vaddy-plugin-1.1" = mkJenkinsPlugin {
    name = "vaddy-plugin-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/vaddy-plugin/1.1/vaddy-plugin.hpi";
      sha256 = "1l1nhpsyj1yc9r9sgf2zahxd2zwal5498b3cblr6cm255ljlx8c6";
    };
  };
  "vagrant-1.0.1" = mkJenkinsPlugin {
    name = "vagrant-1.0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/vagrant/1.0.1/vagrant.hpi";
      sha256 = "02gkkf47j6r4zs8ps7qxvl1wh5ii707lhqwm3m3si00myhsldqf2";
    };
  };
  "valgrind-0.25" = mkJenkinsPlugin {
    name = "valgrind-0.25";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/valgrind/0.25/valgrind.hpi";
      sha256 = "1p8flqj1sj6xzci6qyj774bqpcvksdrhmqkr47ncngbzxfv5x7n5";
    };
  };
  "validating-string-parameter-2.3" = mkJenkinsPlugin {
    name = "validating-string-parameter-2.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/validating-string-parameter/2.3/validating-string-parameter.hpi";
      sha256 = "0b4liba2l4v5gqnsw4p4d1g3rmi41ljxl9k4c9cqpf1kkwffrakq";
    };
  };
  "vault-scm-plugin-1.1.1" = mkJenkinsPlugin {
    name = "vault-scm-plugin-1.1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/vault-scm-plugin/1.1.1/vault-scm-plugin.hpi";
      sha256 = "09q4mvy7nh7jb5ykhh5ayq88ylpjd7sb6vdl160wm6vpqszphrdq";
    };
  };
  "vboxwrapper-1.3" = mkJenkinsPlugin {
    name = "vboxwrapper-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/vboxwrapper/1.3/vboxwrapper.hpi";
      sha256 = "1w1i9mxfg8j1lrlbd3lmnawmvigzs5cp0dq3vp2lblz1awxs31np";
    };
  };
  "veracode-scanner-1.5" = mkJenkinsPlugin {
    name = "veracode-scanner-1.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/veracode-scanner/1.5/veracode-scanner.hpi";
      sha256 = "0sbik62z7ixaz3n2y43gj8mmn8jy5li4fs3j4n0w9xckl2h2w7b4";
    };
  };
  "versioncolumn-0.2" = mkJenkinsPlugin {
    name = "versioncolumn-0.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/versioncolumn/0.2/versioncolumn.hpi";
      sha256 = "16p081gm4kfyl9jap2083lkdxclywyi6hlj25djpj77gqzj1zkcw";
    };
  };
  "versionnumber-1.6" = mkJenkinsPlugin {
    name = "versionnumber-1.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/versionnumber/1.6/versionnumber.hpi";
      sha256 = "1r2l8g0hbmkjkfm9p48xj6hcl2ig8ncxxbh764q6p6qnfqklkddw";
    };
  };
  "vertx-1.0.1" = mkJenkinsPlugin {
    name = "vertx-1.0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/vertx/1.0.1/vertx.hpi";
      sha256 = "07ggqp7vnwy24pv1396d9swdzfqmmasjnxzag0yqf2fpay7gg3jm";
    };
  };
  "vessel-1.0.1" = mkJenkinsPlugin {
    name = "vessel-1.0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/vessel/1.0.1/vessel.hpi";
      sha256 = "1lyqwbm0jys2qkivy17b0lmzh9w8vjc7d7azya2a3c8cs9gspmcp";
    };
  };
  "view-job-filters-1.27" = mkJenkinsPlugin {
    name = "view-job-filters-1.27";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/view-job-filters/1.27/view-job-filters.hpi";
      sha256 = "0s7zqa2hbkz77jcjqbkg6js4xvm0qi216h61xq7zcf1zzhyk38hn";
    };
  };
  "viewVC-1.7" = mkJenkinsPlugin {
    name = "viewVC-1.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/viewVC/1.7/viewVC.hpi";
      sha256 = "19gnmfn2pdiakqxm9mnkgpgd6g517r29731m7jxy1mkq6ij6mmwk";
    };
  };
  "violation-columns-1.6" = mkJenkinsPlugin {
    name = "violation-columns-1.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/violation-columns/1.6/violation-columns.hpi";
      sha256 = "11nrrwzh6hk787525qiqwrl0w2mm0d5rs1gvs0yskvqx1j5kaq5i";
    };
  };
  "violation-comments-to-stash-1.10" = mkJenkinsPlugin {
    name = "violation-comments-to-stash-1.10";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/violation-comments-to-stash/1.10/violation-comments-to-stash.hpi";
      sha256 = "0r7zapi2rpyrjnps50yfyjc778nn7snyfr5300lqqwvadxmcc0fv";
    };
  };
  "violations-0.7.11" = mkJenkinsPlugin {
    name = "violations-0.7.11";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/violations/0.7.11/violations.hpi";
      sha256 = "0ynnwayqhk8mx4gaqw9njdr0lllyz37436h008vkzy01xd9wpspq";
    };
  };
  "virtualbox-0.7" = mkJenkinsPlugin {
    name = "virtualbox-0.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/virtualbox/0.7/virtualbox.hpi";
      sha256 = "1zgbnk5pp6r5n0cvlm8mx0r1dazfshvrwhi4kbka0sji25y7989b";
    };
  };
  "visualworks-store-1.1.1" = mkJenkinsPlugin {
    name = "visualworks-store-1.1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/visualworks-store/1.1.1/visualworks-store.hpi";
      sha256 = "0znq6k2vv2hzhimq1dfnzbmb8ikwgf89g414dfklq7fwf13h07ca";
    };
  };
  "vmanager-plugin-1.6" = mkJenkinsPlugin {
    name = "vmanager-plugin-1.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/vmanager-plugin/1.6/vmanager-plugin.hpi";
      sha256 = "0hfncqnyhqaqk4v6b5kzrj3p98p6jcykc8xybyrn6sgpy6zqmyan";
    };
  };
  "vmware-vrealize-automation-plugin-1.0.1" = mkJenkinsPlugin {
    name = "vmware-vrealize-automation-plugin-1.0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/vmware-vrealize-automation-plugin/1.0.1/vmware-vrealize-automation-plugin.hpi";
      sha256 = "048y5j011585brw19g6ipmrg0nwy357ag6jc3zq0n7fhz97g4fmi";
    };
  };
  "vmware-vrealize-codestream-1.2" = mkJenkinsPlugin {
    name = "vmware-vrealize-codestream-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/vmware-vrealize-codestream/1.2/vmware-vrealize-codestream.hpi";
      sha256 = "1b2mb0g1pia48dvvvj4612gr6zcc5q64j0qbw1xqks0pf2sx80dq";
    };
  };
  "vmware-0.8" = mkJenkinsPlugin {
    name = "vmware-0.8";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/vmware/0.8/vmware.hpi";
      sha256 = "15wb0i9q9ym27r0zq1l76zxv4z9p03sg6il66x03dbb1jvqq3rd3";
    };
  };
  "vncrecorder-1.25" = mkJenkinsPlugin {
    name = "vncrecorder-1.25";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/vncrecorder/1.25/vncrecorder.hpi";
      sha256 = "0h01dqzzgckdpb12apwnwlmkiw70c06rspxq3d54y6089nn6b89s";
    };
  };
  "vncviewer-1.5" = mkJenkinsPlugin {
    name = "vncviewer-1.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/vncviewer/1.5/vncviewer.hpi";
      sha256 = "1hjzc7pw1z9vnpf4g5kbsq1fpxpg0w9ivjb495ygdczhifhkm3dh";
    };
  };
  "vs-code-metrics-1.7" = mkJenkinsPlugin {
    name = "vs-code-metrics-1.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/vs-code-metrics/1.7/vs-code-metrics.hpi";
      sha256 = "1m581bkm5rw3z9w6z7nxvb283br2whlpb1zipmrma8q0d9nm3drr";
    };
  };
  "vsphere-cloud-2.10" = mkJenkinsPlugin {
    name = "vsphere-cloud-2.10";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/vsphere-cloud/2.10/vsphere-cloud.hpi";
      sha256 = "0l9m5iiy2p842wqjvigm9whfd09kn8v0xjq5aj8hcbrmwznl2zg6";
    };
  };
  "vss-1.9" = mkJenkinsPlugin {
    name = "vss-1.9";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/vss/1.9/vss.hpi";
      sha256 = "0dk4zc9bhjhdlldnck7g9i9zypr1knj2dmydr3az4x7i10s1xac2";
    };
  };
  "vstestrunner-1.0.4" = mkJenkinsPlugin {
    name = "vstestrunner-1.0.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/vstestrunner/1.0.4/vstestrunner.hpi";
      sha256 = "06imq8mzch2cnlrrbldx6k9b0r62aja32ln585kcn7mdvwakkdm3";
    };
  };
  "walti-1.0.1" = mkJenkinsPlugin {
    name = "walti-1.0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/walti/1.0.1/walti.hpi";
      sha256 = "09yk8bhi78v8zp8r3n692cyp7ypm2il7facr7050yz9j8c5g0rxh";
    };
  };
  "warnings-4.51" = mkJenkinsPlugin {
    name = "warnings-4.51";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/warnings/4.51/warnings.hpi";
      sha256 = "0ilkkqr8xnfscjb1dq8f4any5x34dw6a1wcifzihkaa60h6iawk9";
    };
  };
  "was-builder-1.6.1" = mkJenkinsPlugin {
    name = "was-builder-1.6.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/was-builder/1.6.1/was-builder.hpi";
      sha256 = "1izazjiicryg5lyr518hpmmhqklpc1llvcgyfhb16yrwy5nwqy26";
    };
  };
  "webload-1.0" = mkJenkinsPlugin {
    name = "webload-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/webload/1.0/webload.hpi";
      sha256 = "1zgbhjklhdwbhs4q9gxwkhw6i0wiwd8xbg1jnm0g4ngh21axskgp";
    };
  };
  "weblogic-deployer-plugin-3.3" = mkJenkinsPlugin {
    name = "weblogic-deployer-plugin-3.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/weblogic-deployer-plugin/3.3/weblogic-deployer-plugin.hpi";
      sha256 = "1jhx7wh6xlyp178jrwcvah83nnn8qvfw0sqaw8s3vj70cfm7jvxc";
    };
  };
  "websocket-1.0.6" = mkJenkinsPlugin {
    name = "websocket-1.0.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/websocket/1.0.6/websocket.hpi";
      sha256 = "0pzydbmxanqv019lclc1cg31r7aim9dk3wmwhhnx7pjzlhqx8awc";
    };
  };
  "websphere-deployer-1.3.4" = mkJenkinsPlugin {
    name = "websphere-deployer-1.3.4";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/websphere-deployer/1.3.4/websphere-deployer.hpi";
      sha256 = "0vilb7ip24gv27vhq3zyw1mcwf4bkpja7xv764frdln9jsa9bfdy";
    };
  };
  "webtestpresenter-0.23" = mkJenkinsPlugin {
    name = "webtestpresenter-0.23";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/webtestpresenter/0.23/webtestpresenter.hpi";
      sha256 = "159s1vax1s6l5drsgyjkggglaaxwpgkg1jwdf0bpihl33yk504zp";
    };
  };
  "weibo-1.0.1" = mkJenkinsPlugin {
    name = "weibo-1.0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/weibo/1.0.1/weibo.hpi";
      sha256 = "18phsn8ql8lp2gywc8pxhxfpy3l986l65b331h1qv0ins5j5zlcl";
    };
  };
  "whitesource-1.5.2" = mkJenkinsPlugin {
    name = "whitesource-1.5.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/whitesource/1.5.2/whitesource.hpi";
      sha256 = "12b20nslgq2k0xm6hybyvi4hk92f839a37d565xqwc6yp9f4vi95";
    };
  };
  "wildfly-deployer-1.0.1" = mkJenkinsPlugin {
    name = "wildfly-deployer-1.0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/wildfly-deployer/1.0.1/wildfly-deployer.hpi";
      sha256 = "17hls1pppciaszlmn0xb5vqfyylp360krs983dw8hq1n1wmi8mq0";
    };
  };
  "windmill-1.5" = mkJenkinsPlugin {
    name = "windmill-1.5";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/windmill/1.5/windmill.hpi";
      sha256 = "0pdbn1c9gm8pyazn5xzyzcy6s7qgw6248qyrfhmww5dhly3xzbcq";
    };
  };
  "windows-azure-storage-0.3.1" = mkJenkinsPlugin {
    name = "windows-azure-storage-0.3.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/windows-azure-storage/0.3.1/windows-azure-storage.hpi";
      sha256 = "09s7x7xprfy0m6k7zh41p41rz4bs0lq68z5zkzbxqg1kdxvpmjrr";
    };
  };
  "windows-exe-runner-1.2" = mkJenkinsPlugin {
    name = "windows-exe-runner-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/windows-exe-runner/1.2/windows-exe-runner.hpi";
      sha256 = "1ag88bs6v0cns3ppmcapc3di6mnl5sf9ddhf9aqpi2s1k52n3dnw";
    };
  };
  "windows-slaves-1.1" = mkJenkinsPlugin {
    name = "windows-slaves-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/windows-slaves/1.1/windows-slaves.hpi";
      sha256 = "11hhdg5wy9wympyh1ag58bcapgqx9q0jp1gnyiin1gnachvs68gx";
    };
  };
  "wix-1.12" = mkJenkinsPlugin {
    name = "wix-1.12";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/wix/1.12/wix.hpi";
      sha256 = "1422sjgn3qp3bqlfjqr7zxvjnm0b7w2chznp4hnpm1ghhxakx5i4";
    };
  };
  "workflow-aggregator-1.13" = mkJenkinsPlugin {
    name = "workflow-aggregator-1.13";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/workflow-aggregator/1.13/workflow-aggregator.hpi";
      sha256 = "11nvhb09nih6xm0agmrhj73b314c6r02lx1brcf82zympz9ckxfq";
    };
  };
  "workflow-api-1.13" = mkJenkinsPlugin {
    name = "workflow-api-1.13";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/workflow-api/1.13/workflow-api.hpi";
      sha256 = "184p0kbx7qv00qhi7b3pyhyq2kap3838y8m2aqwx7md036qsa62v";
    };
  };
  "workflow-basic-steps-1.13" = mkJenkinsPlugin {
    name = "workflow-basic-steps-1.13";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/workflow-basic-steps/1.13/workflow-basic-steps.hpi";
      sha256 = "15ipj93y2n5fm4ikcdlz6jnbk5vgh16qhsrv1yzzk6lycma24ss7";
    };
  };
  "workflow-cps-global-lib-1.13" = mkJenkinsPlugin {
    name = "workflow-cps-global-lib-1.13";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/workflow-cps-global-lib/1.13/workflow-cps-global-lib.hpi";
      sha256 = "090cf9bal6g3n2ll8p6ym7bkm1ydww3g3z4qgybrihi8yrgmz4bp";
    };
  };
  "workflow-cps-1.13" = mkJenkinsPlugin {
    name = "workflow-cps-1.13";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/workflow-cps/1.13/workflow-cps.hpi";
      sha256 = "0f2dm05b3xg6x9hy4yxqbnmkna5xbs4xv0rq90rrz6krkjiprvkw";
    };
  };
  "workflow-durable-task-step-1.13" = mkJenkinsPlugin {
    name = "workflow-durable-task-step-1.13";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/workflow-durable-task-step/1.13/workflow-durable-task-step.hpi";
      sha256 = "0fwf95r2da3apa285gmh4jha4zqi930yhbsq05gylr6a4wv3zbkv";
    };
  };
  "workflow-job-1.13" = mkJenkinsPlugin {
    name = "workflow-job-1.13";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/workflow-job/1.13/workflow-job.hpi";
      sha256 = "1b0d6g5iixpgy7qfagvr5jcsggl469wvszmx65rkspn0bqvjpph9";
    };
  };
  "workflow-multibranch-1.13" = mkJenkinsPlugin {
    name = "workflow-multibranch-1.13";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/workflow-multibranch/1.13/workflow-multibranch.hpi";
      sha256 = "01dcx5n8gml31kikhk1rhkbs54p255v7v3vb4yfn75jpq8784sn1";
    };
  };
  "workflow-remote-loader-1.1" = mkJenkinsPlugin {
    name = "workflow-remote-loader-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/workflow-remote-loader/1.1/workflow-remote-loader.hpi";
      sha256 = "1mavphd8wjbp6dgd2fpd3fn17vf9g1bjjfs2dg6m45g0ck5h5bs8";
    };
  };
  "workflow-scm-step-1.13" = mkJenkinsPlugin {
    name = "workflow-scm-step-1.13";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/workflow-scm-step/1.13/workflow-scm-step.hpi";
      sha256 = "09ka7is2n9rncamy3w38cx498nw52wkkz7avpgyj6bgx8ffmlcwa";
    };
  };
  "workflow-step-api-1.13" = mkJenkinsPlugin {
    name = "workflow-step-api-1.13";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/workflow-step-api/1.13/workflow-step-api.hpi";
      sha256 = "19474k7pdpk6riww7q2rbgxmq6xvyqzfdkd7zqbcxib7axvfsd5p";
    };
  };
  "workflow-support-1.13" = mkJenkinsPlugin {
    name = "workflow-support-1.13";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/workflow-support/1.13/workflow-support.hpi";
      sha256 = "085h2jb6cm2v4y1b1gxbzmr8vnkaarvm49651pc30xd2fqm5jcb4";
    };
  };
  "workplace-notifier-1.16" = mkJenkinsPlugin {
    name = "workplace-notifier-1.16";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/workplace-notifier/1.16/workplace-notifier.hpi";
      sha256 = "0498xc4gsjy63d5a3v0z2j8z83il16lz44mr1vbvhxidfzxmyacq";
    };
  };
  "ws-cleanup-0.28" = mkJenkinsPlugin {
    name = "ws-cleanup-0.28";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/ws-cleanup/0.28/ws-cleanup.hpi";
      sha256 = "1idqipwfwmim7wm88y15y7rk441hjwmdf4nz114w1qjb7j3fhmkp";
    };
  };
  "wwpass-plugin-2.0" = mkJenkinsPlugin {
    name = "wwpass-plugin-2.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/wwpass-plugin/2.0/wwpass-plugin.hpi";
      sha256 = "0bmqkdabzvif0sl6mrzsz2807kbb9zrsbjp0vwj8nhyki8hsj6zq";
    };
  };
  "xcode-plugin-1.4.9" = mkJenkinsPlugin {
    name = "xcode-plugin-1.4.9";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/xcode-plugin/1.4.9/xcode-plugin.hpi";
      sha256 = "0qkmpcgnl0hkjhsrrbk146q8gq7s4wfcjawra6s16l6n058rs19i";
    };
  };
  "xcp-ci-0.5.2" = mkJenkinsPlugin {
    name = "xcp-ci-0.5.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/xcp-ci/0.5.2/xcp-ci.hpi";
      sha256 = "0dcx2kv42by794280i02cs0q190gixnqqvrxwk7r3m2c3vw6gbc3";
    };
  };
  "xfpanel-2.0.1" = mkJenkinsPlugin {
    name = "xfpanel-2.0.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/xfpanel/2.0.1/xfpanel.hpi";
      sha256 = "0k8q5fai666hk6y1ldqkk2za8azqrmh4g909b893m7hb1k9mcrfl";
    };
  };
  "xframe-filter-plugin-1.2" = mkJenkinsPlugin {
    name = "xframe-filter-plugin-1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/xframe-filter-plugin/1.2/xframe-filter-plugin.hpi";
      sha256 = "1k21bs2a8223f5iq5nlhrgs8fnnj36a0lnmrwkam9md2x7zqpspz";
    };
  };
  "xlrelease-plugin-4.8.0" = mkJenkinsPlugin {
    name = "xlrelease-plugin-4.8.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/xlrelease-plugin/4.8.0/xlrelease-plugin.hpi";
      sha256 = "1v4qw8hzbdswx0792wl01js4j51xbamsdhh7j3cp199vsnff656j";
    };
  };
  "xltestview-plugin-1.1.0" = mkJenkinsPlugin {
    name = "xltestview-plugin-1.1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/xltestview-plugin/1.1.0/xltestview-plugin.hpi";
      sha256 = "0mz9hm5p572wppbrfczld19q8yy125wby0w7ncpwp04m3j343ipz";
    };
  };
  "xpath-config-viewer-1.1.1" = mkJenkinsPlugin {
    name = "xpath-config-viewer-1.1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/xpath-config-viewer/1.1.1/xpath-config-viewer.hpi";
      sha256 = "0h4c7nfqd5scg07z0zfpjvg7nr34q8v2v6q2x2xiawphas2fqw10";
    };
  };
  "xpdev-1.0" = mkJenkinsPlugin {
    name = "xpdev-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/xpdev/1.0/xpdev.hpi";
      sha256 = "1z10618h8vjr3xik70f5c62sz1mid090prdxv24xwibach0ad69m";
    };
  };
  "xshell-0.10" = mkJenkinsPlugin {
    name = "xshell-0.10";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/xshell/0.10/xshell.hpi";
      sha256 = "1i3255irsch1kbccqba8mjkqmjvxhyllzlywf529cnqhkvv4c4ch";
    };
  };
  "xtrigger-0.54" = mkJenkinsPlugin {
    name = "xtrigger-0.54";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/xtrigger/0.54/xtrigger.hpi";
      sha256 = "1sylzgnswwjdjv6hcxxbja6mg72k9dn4nb7yg17mwkbsikllprh8";
    };
  };
  "xunit-1.100" = mkJenkinsPlugin {
    name = "xunit-1.100";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/xunit/1.100/xunit.hpi";
      sha256 = "1rah086g4gccx3180h3nm9d1b4mh4dm3pka5vfigzafrfgarhg00";
    };
  };
  "xvfb-1.1.2" = mkJenkinsPlugin {
    name = "xvfb-1.1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/xvfb/1.1.2/xvfb.hpi";
      sha256 = "0hjhc2psffp0mhnbiq3l97vs25b41zdn8b6k0lldc6v55crpdlcb";
    };
  };
  "xvnc-1.23" = mkJenkinsPlugin {
    name = "xvnc-1.23";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/xvnc/1.23/xvnc.hpi";
      sha256 = "0dx5c2gx5lv4s7q6l5n9568xwq51522kc1g46a3bfvazxmfq4bzh";
    };
  };
  "yaml-axis-0.1.2" = mkJenkinsPlugin {
    name = "yaml-axis-0.1.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/yaml-axis/0.1.2/yaml-axis.hpi";
      sha256 = "0dj1p9hh3pp2aydzl4mk1gmcjl9qymvi4w8a6hpwagfy1ywi0n5a";
    };
  };
  "yammer-1.1.0" = mkJenkinsPlugin {
    name = "yammer-1.1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/yammer/1.1.0/yammer.hpi";
      sha256 = "1vz9m63xy8gpmkn7v07krcbq8gyqmx96mfsx6yg42ldlzn5ppzlg";
    };
  };
  "yandex-metrica-1.0" = mkJenkinsPlugin {
    name = "yandex-metrica-1.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/yandex-metrica/1.0/yandex-metrica.hpi";
      sha256 = "0kb4j5rzd07r812kd8r8zffmkpys0mmaaacmzgh0pjikf9hjmj73";
    };
  };
  "yet-another-docker-plugin-0.1.0-rc2" = mkJenkinsPlugin {
    name = "yet-another-docker-plugin-0.1.0-rc2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/yet-another-docker-plugin/0.1.0-rc2/yet-another-docker-plugin.hpi";
      sha256 = "0wrdgyk84flairl123xb1xsyx5x3nfgjyyhysd39f2yv3hldk493";
    };
  };
  "youtrack-plugin-0.6.6" = mkJenkinsPlugin {
    name = "youtrack-plugin-0.6.6";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/youtrack-plugin/0.6.6/youtrack-plugin.hpi";
      sha256 = "1g790i7mb7i06364r4qxkc8v0gsvivwcnhpjvir6an0zpz9nxbwp";
    };
  };
  "zapper-1.0.7" = mkJenkinsPlugin {
    name = "zapper-1.0.7";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/zapper/1.0.7/zapper.hpi";
      sha256 = "18szk7m5h128swg9576y3ng3gjhjd45l98kw8f53i9b9pi5bch4j";
    };
  };
  "zaproxy-1.2.0" = mkJenkinsPlugin {
    name = "zaproxy-1.2.0";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/zaproxy/1.2.0/zaproxy.hpi";
      sha256 = "19g0d5yrqq8qm3n571xgi6qjggwp6xcqlyp78pr0fk7hrkycsh6a";
    };
  };
  "zentimestamp-4.2" = mkJenkinsPlugin {
    name = "zentimestamp-4.2";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/zentimestamp/4.2/zentimestamp.hpi";
      sha256 = "1wa4cf0j9sq04lv85ql13xqhwgcgsdzca5n6iry5w4612cz4vkqj";
    };
  };
  "zephyr-enterprise-test-management-1.1" = mkJenkinsPlugin {
    name = "zephyr-enterprise-test-management-1.1";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/zephyr-enterprise-test-management/1.1/zephyr-enterprise-test-management.hpi";
      sha256 = "0naimg9n1fwwnry4xkzj2lnbcx238klm076cq7ddj6amyyj1xsb5";
    };
  };
  "zephyr-for-jira-test-management-1.3" = mkJenkinsPlugin {
    name = "zephyr-for-jira-test-management-1.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/zephyr-for-jira-test-management/1.3/zephyr-for-jira-test-management.hpi";
      sha256 = "1lyfbsiy4z9rn0wr0ajr4gykyh0pb5rya83n5vrc5x7cjak7y8fn";
    };
  };
  "zos-connector-1.2.3" = mkJenkinsPlugin {
    name = "zos-connector-1.2.3";
    src = fetchurl {
      url = "https://updates.jenkins-ci.org/download/plugins/zos-connector/1.2.3/zos-connector.hpi";
      sha256 = "0m13yjq0w9l4libri3cydx0i8xjh8rgzqxrj5sx17h3253rwppmq";
    };
  };
}
