{
  lib,
  stdenv,
  aiobotocore,
  boto3,
  botocore,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

let
  toUnderscore = str: builtins.replaceStrings [ "-" ] [ "_" ] str;
  buildTypesAiobotocorePackage =
    serviceName: version: hash:
    buildPythonPackage rec {
      pname = "types-aiobotocore-${serviceName}";
      inherit version;
      pyproject = true;

      disabled = pythonOlder "3.7";

      oldStylePackages = [
        "gamesparks"
        "iot-roborunner"
        "macie"
      ];

      src = fetchPypi {
        pname =
          if builtins.elem serviceName oldStylePackages then
            "types-aiobotocore-${serviceName}"
          else
            "types_aiobotocore_${toUnderscore serviceName}";
        inherit version hash;
      };

      build-system = [ setuptools ];

      dependencies = [
        aiobotocore
        boto3
        botocore
      ] ++ lib.optionals (pythonOlder "3.12") [ typing-extensions ];

      # Module has no tests
      doCheck = false;

      pythonImportsCheck = [ "types_aiobotocore_${toUnderscore serviceName}" ];

      meta = with lib; {
        description = "Type annotations for aiobotocore ${serviceName}";
        homepage = "https://github.com/youtype/mypy_boto3_builder";
        license = licenses.mit;
        maintainers = with maintainers; [ mbalatsko ];
      };
    };
in
rec {
  types-aiobotocore-accessanalyzer =
    buildTypesAiobotocorePackage "accessanalyzer" "2.15.0"
      "sha256-aXiUguHjVb9uw4bM1jpJLEFDSJGPEwPVBXUOSylrJUU=";

  types-aiobotocore-account =
    buildTypesAiobotocorePackage "account" "2.15.0"
      "sha256-frvRCAYh+zn8k1AXzGQuH84QnhXyIiUR7BZBZfH5Vao=";

  types-aiobotocore-acm =
    buildTypesAiobotocorePackage "acm" "2.15.0"
      "sha256-au29Nkw94QcHk1c+CCsaNBM+6bkOPPr17yj5naKlFJI=";

  types-aiobotocore-acm-pca =
    buildTypesAiobotocorePackage "acm-pca" "2.15.0"
      "sha256-xLhR9zReaQ4O2ka8SJh6KOEvcoWm/fs+gC7PtRNQtTw=";

  types-aiobotocore-alexaforbusiness =
    buildTypesAiobotocorePackage "alexaforbusiness" "2.13.0"
      "sha256-+w/InoQR2aZ5prieGhgEEp7auBiSSghG5zIIHY5Kyao=";

  types-aiobotocore-amp =
    buildTypesAiobotocorePackage "amp" "2.15.0"
      "sha256-nMLt8ZITr0zwrnG6v12XgpKtuvggXbhCaozMzF6Ng9c=";

  types-aiobotocore-amplify =
    buildTypesAiobotocorePackage "amplify" "2.15.0"
      "sha256-L4P4YRaKsIJkhDT1aOjEs5NxnnXyZoRSPZbIVI0iCfE=";

  types-aiobotocore-amplifybackend =
    buildTypesAiobotocorePackage "amplifybackend" "2.15.0"
      "sha256-bgOAbDajiuw3GQ15XRK6QJoSc+RwjQY1sZt+lLhGONA=";

  types-aiobotocore-amplifyuibuilder =
    buildTypesAiobotocorePackage "amplifyuibuilder" "2.15.0"
      "sha256-N4OTBb2LW3JFJLzE6OeDPAzpjUcSlwPEVezaVelE++o=";

  types-aiobotocore-apigateway =
    buildTypesAiobotocorePackage "apigateway" "2.15.0"
      "sha256-B+QNyR9jyv1+SKTj0fq6qlq1vwQ5yxhf9yvkIjc+AWA=";

  types-aiobotocore-apigatewaymanagementapi =
    buildTypesAiobotocorePackage "apigatewaymanagementapi" "2.15.0"
      "sha256-cNIPbJvmZltZ089CfkfxenyTtJUC/+ETCyEDDlzwLOg=";

  types-aiobotocore-apigatewayv2 =
    buildTypesAiobotocorePackage "apigatewayv2" "2.15.0"
      "sha256-PfwYm2wklpMZdH/DXKOMlOmozwl8PWY/dnGKZ+vDHVM=";

  types-aiobotocore-appconfig =
    buildTypesAiobotocorePackage "appconfig" "2.15.0"
      "sha256-jhXyfuEWN+hc9R3K2zU5DeiIPuz7Gl9GxQBs1VecCZo=";

  types-aiobotocore-appconfigdata =
    buildTypesAiobotocorePackage "appconfigdata" "2.15.0"
      "sha256-rLhZ4JpFtHlBfWgaRl1Y1BkGdy3L0pIK52zni/Jd1UU=";

  types-aiobotocore-appfabric =
    buildTypesAiobotocorePackage "appfabric" "2.15.0"
      "sha256-PtAaUmLoCVRs2UFarVzJSdMjftYrRz4pjb7nraMIAys=";

  types-aiobotocore-appflow =
    buildTypesAiobotocorePackage "appflow" "2.15.0"
      "sha256-Yz7cnhD8peXaYwC4sLbAcjsQFDWWnq4VZKTAOJ3M5YA=";

  types-aiobotocore-appintegrations =
    buildTypesAiobotocorePackage "appintegrations" "2.15.0"
      "sha256-azLPzqojFnj11d8Hw45c+VuZgG/J3KGUhOYD+R7ZwK8=";

  types-aiobotocore-application-autoscaling =
    buildTypesAiobotocorePackage "application-autoscaling" "2.15.0"
      "sha256-NvY9zOt9xDFh0XgUSyAQ1obzttIj8BXOa8qBWjJ/VLs=";

  types-aiobotocore-application-insights =
    buildTypesAiobotocorePackage "application-insights" "2.15.0"
      "sha256-g4NHKgSExk9Xb6xmNm8kTdrWP473KN+AHs1vw9l6yL0=";

  types-aiobotocore-applicationcostprofiler =
    buildTypesAiobotocorePackage "applicationcostprofiler" "2.15.0"
      "sha256-AZG2e70N6u+tYQF9rsxG/kCO/fCJiBtvmdaSQvEwLLo=";

  types-aiobotocore-appmesh =
    buildTypesAiobotocorePackage "appmesh" "2.15.0"
      "sha256-Qn/Nw8OnHixSWzjJPxN2T7B8mzscpDdBNgjNrefOgmM=";

  types-aiobotocore-apprunner =
    buildTypesAiobotocorePackage "apprunner" "2.15.0"
      "sha256-rjBxiphEQxs5/OZVEPDM45YIivDCrjVkkK4bLbUgvDM=";

  types-aiobotocore-appstream =
    buildTypesAiobotocorePackage "appstream" "2.15.0"
      "sha256-tlmIQ+6d7lNhZiDtSiF6SodUtwLTJJkJSofMb5YUW1Q=";

  types-aiobotocore-appsync =
    buildTypesAiobotocorePackage "appsync" "2.15.0"
      "sha256-kR3BQccO7l3TixcVmDOVu41t5gJPBpFedgk5uPLuDxU=";

  types-aiobotocore-arc-zonal-shift =
    buildTypesAiobotocorePackage "arc-zonal-shift" "2.15.0"
      "sha256-o9pDedTVsRr98GZwtFbfFwKZwOA0e4zseGSFtlBEsLQ=";

  types-aiobotocore-athena =
    buildTypesAiobotocorePackage "athena" "2.15.0"
      "sha256-AgWHakNCla5JY6zz0rWLwkorVESJCvQG6jhT1OFRNUY=";

  types-aiobotocore-auditmanager =
    buildTypesAiobotocorePackage "auditmanager" "2.15.0"
      "sha256-U5ir/tSKwIAIF2TVJ66L1utVyh9cscc7z2VyrcsrGoI=";

  types-aiobotocore-autoscaling =
    buildTypesAiobotocorePackage "autoscaling" "2.15.0"
      "sha256-7ZKRN/IlUrNvFgeuGbo242Di4eyIDr9/5tJsHrgcspg=";

  types-aiobotocore-autoscaling-plans =
    buildTypesAiobotocorePackage "autoscaling-plans" "2.15.0"
      "sha256-Va74FcUxerO1nEtm6AiWbaw8zVHDkrdsfq3fBlznM7k=";

  types-aiobotocore-backup =
    buildTypesAiobotocorePackage "backup" "2.15.0"
      "sha256-9k/3D58OtYwyGl/B9wepaNbj6vgxzqc9E96Tp5+qSVU=";

  types-aiobotocore-backup-gateway =
    buildTypesAiobotocorePackage "backup-gateway" "2.15.0"
      "sha256-pp75wX3UeV4U7UChs3EyanPom1UD6RCYdYfVmN21MjM=";

  types-aiobotocore-backupstorage =
    buildTypesAiobotocorePackage "backupstorage" "2.13.0"
      "sha256-YUKtBdBrdwL2yqDqOovvzDPbcv/sD8JLRnKz3Oh7iSU=";

  types-aiobotocore-batch =
    buildTypesAiobotocorePackage "batch" "2.15.0"
      "sha256-vbZk1mR45gdhLVtdZTi0ZG6I72ttUwHqFAuXc4TW8o8=";

  types-aiobotocore-billingconductor =
    buildTypesAiobotocorePackage "billingconductor" "2.15.0"
      "sha256-mtbJipKOB82AHWrRAfNFUgHTwNtqiU/NSn9F6eLcqok=";

  types-aiobotocore-braket =
    buildTypesAiobotocorePackage "braket" "2.15.0"
      "sha256-Hu8DNQCusy3HR5NNptB4Rwuhu3m9lcqTgR7HnZMjtwA=";

  types-aiobotocore-budgets =
    buildTypesAiobotocorePackage "budgets" "2.15.0"
      "sha256-E8f8+ONZep2G/BoOSinere9SIMetZHNK+FpmfJZtXxY=";

  types-aiobotocore-ce =
    buildTypesAiobotocorePackage "ce" "2.15.0"
      "sha256-8FK+wf201DspWWW338aad19mh84tEqI84GqKE9zclyA=";

  types-aiobotocore-chime =
    buildTypesAiobotocorePackage "chime" "2.15.0"
      "sha256-mAgx2hqP0zIvMIdAlyqD6A9HVZ0l/CKDj1lAvsDP/60=";

  types-aiobotocore-chime-sdk-identity =
    buildTypesAiobotocorePackage "chime-sdk-identity" "2.15.0"
      "sha256-aY7LS0tEdBVxPwUIrR10ukCybglu1iQIyohNkMHrD4I=";

  types-aiobotocore-chime-sdk-media-pipelines =
    buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "2.15.0"
      "sha256-34bU9wxdytAbTYBGM4/sfAn1tYtYLEc2dpUN+t4RtP4=";

  types-aiobotocore-chime-sdk-meetings =
    buildTypesAiobotocorePackage "chime-sdk-meetings" "2.15.0"
      "sha256-X6YpdEVXPHsvDjptcowPEs71b6iVHO5s80VmO8yEG0o=";

  types-aiobotocore-chime-sdk-messaging =
    buildTypesAiobotocorePackage "chime-sdk-messaging" "2.15.0"
      "sha256-6CI5unJa7Ba1agD41zvcg7hi76D5j34NF5WlPAzkZiY=";

  types-aiobotocore-chime-sdk-voice =
    buildTypesAiobotocorePackage "chime-sdk-voice" "2.15.0"
      "sha256-Qz3MHsRX3k9pxSZAltP3CrwFB3jcdNQkVok3jAUbXa8=";

  types-aiobotocore-cleanrooms =
    buildTypesAiobotocorePackage "cleanrooms" "2.15.0"
      "sha256-d+cISH+Wz1tnTh3hl1V0VLmHAirfi5puzLE1llIb6SY=";

  types-aiobotocore-cloud9 =
    buildTypesAiobotocorePackage "cloud9" "2.15.0"
      "sha256-4+/5CcjgXH4O2LXpOUbDNXC2xMnVzU9e4eY0n6tA39I=";

  types-aiobotocore-cloudcontrol =
    buildTypesAiobotocorePackage "cloudcontrol" "2.15.0"
      "sha256-5yjSbImILBpPJrwJUabP/z37yocdAtASsS0sSfJq69Q=";

  types-aiobotocore-clouddirectory =
    buildTypesAiobotocorePackage "clouddirectory" "2.15.0"
      "sha256-0+bbLpb+IIfgPFd2mltYjgDhV94hmD9nBHu+kOFPRbs=";

  types-aiobotocore-cloudformation =
    buildTypesAiobotocorePackage "cloudformation" "2.15.0"
      "sha256-KV6YLm057AqItUSfZmlMro41bvzyWitf64KXh/S78BM=";

  types-aiobotocore-cloudfront =
    buildTypesAiobotocorePackage "cloudfront" "2.15.0"
      "sha256-G1vjQh+/51KC5GLbqu8id0vIMcllM6e249ibRWIc+50=";

  types-aiobotocore-cloudhsm =
    buildTypesAiobotocorePackage "cloudhsm" "2.15.0"
      "sha256-zFlLFb3Kg+n4aK0laLFxbyqBh5ljI9q38Hh+tK/9o3Q=";

  types-aiobotocore-cloudhsmv2 =
    buildTypesAiobotocorePackage "cloudhsmv2" "2.15.0"
      "sha256-VkQmIJDWE+9VksOnEyLtktWOfNgRRw76zqr8xM7TM40=";

  types-aiobotocore-cloudsearch =
    buildTypesAiobotocorePackage "cloudsearch" "2.15.0"
      "sha256-56M9O04QpzTvwBM6kTBlq/xlKulSye55n2yTqjibAhM=";

  types-aiobotocore-cloudsearchdomain =
    buildTypesAiobotocorePackage "cloudsearchdomain" "2.15.0"
      "sha256-c2MkpaPyF+fpbQMMC2UvP8HvWOxXz1zoKlmy8mWihKg=";

  types-aiobotocore-cloudtrail =
    buildTypesAiobotocorePackage "cloudtrail" "2.15.0"
      "sha256-3oPEyW12otLcBEs3PM4ySpx8REN1XbOveu/H3/tMlyk=";

  types-aiobotocore-cloudtrail-data =
    buildTypesAiobotocorePackage "cloudtrail-data" "2.15.0"
      "sha256-jwYk+AdycgvN5G26/e4E6xTvXqhSau5uXHOdn8QOz4A=";

  types-aiobotocore-cloudwatch =
    buildTypesAiobotocorePackage "cloudwatch" "2.15.0"
      "sha256-tSEIoJJZ3Qkta6R7urcY6o0Zmh/inayk9TFmWDtBxrI=";

  types-aiobotocore-codeartifact =
    buildTypesAiobotocorePackage "codeartifact" "2.15.0"
      "sha256-Uh628mId25sRK5C1RiFFUhnm3gwoAOn1qBiYFEZawiQ=";

  types-aiobotocore-codebuild =
    buildTypesAiobotocorePackage "codebuild" "2.15.0"
      "sha256-Vpmwx9NLkvW8//lwYbuNn4oCuTGlOzW6ALQvkNw3zjk=";

  types-aiobotocore-codecatalyst =
    buildTypesAiobotocorePackage "codecatalyst" "2.15.0"
      "sha256-hLZYCwF1SvMp2Pmhg14E/I0QmkFHdBivYL4zwbeozAc=";

  types-aiobotocore-codecommit =
    buildTypesAiobotocorePackage "codecommit" "2.15.0"
      "sha256-ChHQF79gsoOzTA8Gzg3e7U4DRW24PsP2joi7haolI5U=";

  types-aiobotocore-codedeploy =
    buildTypesAiobotocorePackage "codedeploy" "2.15.0"
      "sha256-CldfAcuTTh8Xf1alyNDfEaJb+7wOLhQKg+S4GrnhPT4=";

  types-aiobotocore-codeguru-reviewer =
    buildTypesAiobotocorePackage "codeguru-reviewer" "2.15.0"
      "sha256-I2WeTiUX7skEx1Ow8VQjsyBFk0ibYVqjM0SQwd+Djok=";

  types-aiobotocore-codeguru-security =
    buildTypesAiobotocorePackage "codeguru-security" "2.15.0"
      "sha256-yF6I+I+KPEVXogQ4kON3OUq+G+DmxaIwykJm521Lw1I=";

  types-aiobotocore-codeguruprofiler =
    buildTypesAiobotocorePackage "codeguruprofiler" "2.15.0"
      "sha256-/eRwr2fqu4i17bt9mG7Ffwh/QKBt8cx4T1IehPZNbc4=";

  types-aiobotocore-codepipeline =
    buildTypesAiobotocorePackage "codepipeline" "2.15.0"
      "sha256-i1HlE4mnLkBcbH9BlEUiMswVoDvdFqkA2db/ONYTs9o=";

  types-aiobotocore-codestar =
    buildTypesAiobotocorePackage "codestar" "2.13.3"
      "sha256-Z1ewx2RjmxbOQZ7wXaN54PVOuRs6LP3rMpsrVTacwjo=";

  types-aiobotocore-codestar-connections =
    buildTypesAiobotocorePackage "codestar-connections" "2.15.0"
      "sha256-ksiIt34O0vVOmlaSZjfPugnYUQDzUj9go5hIOknyvHM=";

  types-aiobotocore-codestar-notifications =
    buildTypesAiobotocorePackage "codestar-notifications" "2.15.0"
      "sha256-vbNr4u4HAHEUaXyUruJtNRk1urlJ6W7yUJrS6ULE+2s=";

  types-aiobotocore-cognito-identity =
    buildTypesAiobotocorePackage "cognito-identity" "2.15.0"
      "sha256-uFRD5fzIN11WLtR6KQ10IKxWpzf/Lr2q5VHHdC++h5U=";

  types-aiobotocore-cognito-idp =
    buildTypesAiobotocorePackage "cognito-idp" "2.15.0"
      "sha256-Yz1fDkWhQCsDN0I/KE8mkmKsVG+pzRMbyOighcdE+68=";

  types-aiobotocore-cognito-sync =
    buildTypesAiobotocorePackage "cognito-sync" "2.15.0"
      "sha256-IAbAdXXV/qBLu4g4sxbk8PAlJ61fL1788sKrOCAPoyA=";

  types-aiobotocore-comprehend =
    buildTypesAiobotocorePackage "comprehend" "2.15.0"
      "sha256-o78Qq1eZTT/+3oSdpDMFGT3VcRr3BUgTHIEv9U6zsaw=";

  types-aiobotocore-comprehendmedical =
    buildTypesAiobotocorePackage "comprehendmedical" "2.15.0"
      "sha256-cdmbnC12r0nzgqHt9MZsB8z34Gh1wLr7pressaGNdok=";

  types-aiobotocore-compute-optimizer =
    buildTypesAiobotocorePackage "compute-optimizer" "2.15.0"
      "sha256-OiZkYLcHvGfgrAAG/g2DI7OfTXuowz9U9vgYnUnQ5LY=";

  types-aiobotocore-config =
    buildTypesAiobotocorePackage "config" "2.15.0"
      "sha256-t4TXmT50janvS0/t4x7a1Kugx+spLVtdhYXk0tbW7IA=";

  types-aiobotocore-connect =
    buildTypesAiobotocorePackage "connect" "2.15.0"
      "sha256-sqLlspZPLtilYBBOQtHV5YT3IZ2BJCenD2r8D8JUva0=";

  types-aiobotocore-connect-contact-lens =
    buildTypesAiobotocorePackage "connect-contact-lens" "2.15.0"
      "sha256-B2MqOOHJs3cHIuPKPJPdGsw/htwbTdqhF3vX2ErhSUs=";

  types-aiobotocore-connectcampaigns =
    buildTypesAiobotocorePackage "connectcampaigns" "2.15.0"
      "sha256-ILLDJbAD7jQdyUop5NzZA5YOzCvDLS5DwjRaPqiHFZc=";

  types-aiobotocore-connectcases =
    buildTypesAiobotocorePackage "connectcases" "2.15.0"
      "sha256-XM58yx4FP5mfVcdXpGOCXk3HrYbhiPbKhFLYMjKJfjE=";

  types-aiobotocore-connectparticipant =
    buildTypesAiobotocorePackage "connectparticipant" "2.15.0"
      "sha256-nEouxJuZHsnNuIXSFpW1r5eWp7wiM525jaqkrHKy27o=";

  types-aiobotocore-controltower =
    buildTypesAiobotocorePackage "controltower" "2.15.0"
      "sha256-pI3tNm75uKX9qYGq0wdINP/ikm1Q11Y2Y+buuSUhMqU=";

  types-aiobotocore-cur =
    buildTypesAiobotocorePackage "cur" "2.15.0"
      "sha256-YE6vdELZULQU8zYRFd97IEWw+guKLJM24VhxRjbCHNk=";

  types-aiobotocore-customer-profiles =
    buildTypesAiobotocorePackage "customer-profiles" "2.15.0"
      "sha256-Gq+W7nn4AaMd51nYd0uzDfDNWqMsqwYTBR8JA63NCtI=";

  types-aiobotocore-databrew =
    buildTypesAiobotocorePackage "databrew" "2.15.0"
      "sha256-cKk8cRR2XcMCIbBeg9g2Zgwun5/RRNQaiAKoIv8WvEk=";

  types-aiobotocore-dataexchange =
    buildTypesAiobotocorePackage "dataexchange" "2.15.0"
      "sha256-0ZZcNnUh2X/K7t65yy0CJS7JDNqn//a/CEn/ujyBpjU=";

  types-aiobotocore-datapipeline =
    buildTypesAiobotocorePackage "datapipeline" "2.15.0"
      "sha256-DeudpMd35JzfAn2Oi9J8IQdLzoL82YqUAP1sfJV2Mes=";

  types-aiobotocore-datasync =
    buildTypesAiobotocorePackage "datasync" "2.15.0"
      "sha256-E3SzICSZSRfKzcyUs1pXzg+jrAC6YX6S4FVUp6bqjqI=";

  types-aiobotocore-dax =
    buildTypesAiobotocorePackage "dax" "2.15.0"
      "sha256-CShLLvZXv9Wl2ipx7Yo/9EZgFd8xC51rTn+3s5IQtJs=";

  types-aiobotocore-detective =
    buildTypesAiobotocorePackage "detective" "2.15.0"
      "sha256-1JpQFNtq/ER6zmTYo1glMgxKVz4ctYwQa3cm69otc14=";

  types-aiobotocore-devicefarm =
    buildTypesAiobotocorePackage "devicefarm" "2.15.0"
      "sha256-tRLyH18/lVx4skaoAk73cd2lE6sBJ+d8DMUaHxXIVkg=";

  types-aiobotocore-devops-guru =
    buildTypesAiobotocorePackage "devops-guru" "2.15.0"
      "sha256-2Bv8N9q/i0WFB+F8Xu8BQZ7ws+7yJa7qgjaE7X1dQB0=";

  types-aiobotocore-directconnect =
    buildTypesAiobotocorePackage "directconnect" "2.15.0"
      "sha256-hY2hLmFtlsggdE6gyQ9lwjTjfkgfaGvWudSPcTy18NU=";

  types-aiobotocore-discovery =
    buildTypesAiobotocorePackage "discovery" "2.15.0"
      "sha256-RnQoddR4qXiAItydDAFBTOkEsBg+DHolqqdHyfCTqXM=";

  types-aiobotocore-dlm =
    buildTypesAiobotocorePackage "dlm" "2.15.0"
      "sha256-/lzVDT2qoK+6PrUozdrSyN7QTcygA7IyUGl7E1K0t4Y=";

  types-aiobotocore-dms =
    buildTypesAiobotocorePackage "dms" "2.15.0"
      "sha256-9JKz+NHAudWbLGVL5L8fZwoTcom3o7JNFioRNYoVQ0Q=";

  types-aiobotocore-docdb =
    buildTypesAiobotocorePackage "docdb" "2.15.0"
      "sha256-ZEdJM8Z7ngpa7LIMyL9+jRi0EL2IRcoG12O+cr2roYU=";

  types-aiobotocore-docdb-elastic =
    buildTypesAiobotocorePackage "docdb-elastic" "2.15.0"
      "sha256-kKf2pjIGoGuO/V/LjIDBPF+Kv0rhEO0kSCLsJe1npc8=";

  types-aiobotocore-drs =
    buildTypesAiobotocorePackage "drs" "2.15.0"
      "sha256-HxY54FJDM6VQuSAB7Qy1PNT9EhPF5z8NXn+m1ICe+aI=";

  types-aiobotocore-ds =
    buildTypesAiobotocorePackage "ds" "2.15.0"
      "sha256-iAq4ovzPUAjfH6DE94F5IJoOXMtLr3MF6b+ITByTE2c=";

  types-aiobotocore-dynamodb =
    buildTypesAiobotocorePackage "dynamodb" "2.15.0"
      "sha256-TBiXxLLpyYHslMBCGjPVEOke+7/kj2YcBSMMNpe/d3s=";

  types-aiobotocore-dynamodbstreams =
    buildTypesAiobotocorePackage "dynamodbstreams" "2.15.0"
      "sha256-RRg/aabmM+Vl4b3HwafJVrIc/khRLhgVN9uflG8IGi4=";

  types-aiobotocore-ebs =
    buildTypesAiobotocorePackage "ebs" "2.15.0"
      "sha256-FGLzilsbA3iCnJLkdeBSYNUPsyzz4N6aNX26MUwGKLE=";

  types-aiobotocore-ec2 =
    buildTypesAiobotocorePackage "ec2" "2.15.0"
      "sha256-FnDRizmCPp39EhGU+c9UKJIFz2ZAMlTOaebcLhLBmlY=";

  types-aiobotocore-ec2-instance-connect =
    buildTypesAiobotocorePackage "ec2-instance-connect" "2.15.0"
      "sha256-3KxMgKPAqCHVxv6a/70ykkJPAc/wFUIe+MxlOURCaHY=";

  types-aiobotocore-ecr =
    buildTypesAiobotocorePackage "ecr" "2.15.0"
      "sha256-+bAe56VT/aSJERPDE7/PuBelT5vJubs2j7mJB0pb5rA=";

  types-aiobotocore-ecr-public =
    buildTypesAiobotocorePackage "ecr-public" "2.15.0"
      "sha256-5WJz1uIp+dbP3qqTCieXJBM9TCOWHPOfVQck1G8BkpY=";

  types-aiobotocore-ecs =
    buildTypesAiobotocorePackage "ecs" "2.15.0"
      "sha256-KEE+rLoBBqNtP6AtFT33Xx4TzQydrvyUxKpamHe50jE=";

  types-aiobotocore-efs =
    buildTypesAiobotocorePackage "efs" "2.15.0"
      "sha256-3DZJT/rjzuxNi1oAc51AJguCXN9zI57cYp7Y3wTvtZs=";

  types-aiobotocore-eks =
    buildTypesAiobotocorePackage "eks" "2.15.0"
      "sha256-KEl1qvE3QAnhScIbH9/WkwRDyIHDGNsCnNBom1nkdRg=";

  types-aiobotocore-elastic-inference =
    buildTypesAiobotocorePackage "elastic-inference" "2.15.0"
      "sha256-65/pni/wL4lR1hzu0C7xfVeiT4kzl980hGr/pWJAwvU=";

  types-aiobotocore-elasticache =
    buildTypesAiobotocorePackage "elasticache" "2.15.0"
      "sha256-GlAHYrfqx+VSBuXdwiRY4lUDqcfsmaxVXLwph6d6HCc=";

  types-aiobotocore-elasticbeanstalk =
    buildTypesAiobotocorePackage "elasticbeanstalk" "2.15.0"
      "sha256-Cd16ST0rbvq+NOYAOQgwU2UZWDiKfUTQ4vdxQlP3+Bs=";

  types-aiobotocore-elastictranscoder =
    buildTypesAiobotocorePackage "elastictranscoder" "2.15.0"
      "sha256-3dGv1gPdU/0o0LBYMjzH+uoSMVzhd2dHwZNxt4jdE6U=";

  types-aiobotocore-elb =
    buildTypesAiobotocorePackage "elb" "2.15.0"
      "sha256-Y6J2/ChKP8JnrZEW8StlYONrAfRecKWJbf07I7zxIGI=";

  types-aiobotocore-elbv2 =
    buildTypesAiobotocorePackage "elbv2" "2.15.0"
      "sha256-7m97yZfyrNFCI3zQYdHJ4SJ5oTACcJ+cfzMzX0MSdN8=";

  types-aiobotocore-emr =
    buildTypesAiobotocorePackage "emr" "2.15.0"
      "sha256-4GNDh92LYUWxXjvgiYrOsY2joFbHalolgAWtnd79AJQ=";

  types-aiobotocore-emr-containers =
    buildTypesAiobotocorePackage "emr-containers" "2.15.0"
      "sha256-TnEfypfapADarPuVOfl0SzNnJSFJUQmxmeoDZ869fIk=";

  types-aiobotocore-emr-serverless =
    buildTypesAiobotocorePackage "emr-serverless" "2.15.0"
      "sha256-bjW88670lzwRWbIp5dHEJIf4EfJSOkQl7CIG2G/wpsQ=";

  types-aiobotocore-entityresolution =
    buildTypesAiobotocorePackage "entityresolution" "2.15.0"
      "sha256-9x6SSolu1CVMjQitu4/8QBxxhdk6G65onKE0EW4oGi0=";

  types-aiobotocore-es =
    buildTypesAiobotocorePackage "es" "2.15.0"
      "sha256-s8lgcAKVZH3rxzogSj74xJ98thChBIvePIvJmHKrApc=";

  types-aiobotocore-events =
    buildTypesAiobotocorePackage "events" "2.15.0"
      "sha256-bgdyFuggcdUfDxEtDjgbmCIc88z4wGbdKQrYmIiZKjs=";

  types-aiobotocore-evidently =
    buildTypesAiobotocorePackage "evidently" "2.15.0"
      "sha256-ZNKyeP1THt85PeKqrof84e3glJ4x1TwT0ziqaCXKedk=";

  types-aiobotocore-finspace =
    buildTypesAiobotocorePackage "finspace" "2.15.0"
      "sha256-gvwDgITwyGZFVndTMKIkD0svxPF3Ur09De7rtP1N57A=";

  types-aiobotocore-finspace-data =
    buildTypesAiobotocorePackage "finspace-data" "2.15.0"
      "sha256-+NpGar24GvTd3+3umx0axL2vNJQ0RtDKZzuKvNJu2RY=";

  types-aiobotocore-firehose =
    buildTypesAiobotocorePackage "firehose" "2.15.0"
      "sha256-BD2gBxbEGlAolHT7xHBj58i4zVHXy3o0xGpIprcCA1I=";

  types-aiobotocore-fis =
    buildTypesAiobotocorePackage "fis" "2.15.0"
      "sha256-qRkkIDm1n3z41pVntjSLypDnM3UVQlXuh5A+sWipFGY=";

  types-aiobotocore-fms =
    buildTypesAiobotocorePackage "fms" "2.15.0"
      "sha256-i2wfly+9R4KyK1rsRIwKbK3P6OnXpfCxWC8ZV1Fx1M4=";

  types-aiobotocore-forecast =
    buildTypesAiobotocorePackage "forecast" "2.15.0"
      "sha256-SC0rCCOVa47auM4pasWds3nOzO19anbT5jL1UVIUKXo=";

  types-aiobotocore-forecastquery =
    buildTypesAiobotocorePackage "forecastquery" "2.15.0"
      "sha256-3+z4Ef85r9aOPdkLXV8L/+9MBvQpLNkFIElRBlQLsRo=";

  types-aiobotocore-frauddetector =
    buildTypesAiobotocorePackage "frauddetector" "2.15.0"
      "sha256-UroaCR4B1cgLe4l2+RKdUa9/Q6LLpglmohhYDROSdnU=";

  types-aiobotocore-fsx =
    buildTypesAiobotocorePackage "fsx" "2.15.0"
      "sha256-9iYbsEG4J4HeXBuCiQQtzOLVBzlkkcg404TbQGg+E7E=";

  types-aiobotocore-gamelift =
    buildTypesAiobotocorePackage "gamelift" "2.15.0"
      "sha256-x9KREjqQw/DMOD3cbdw19mH4zOxvqKcMIRe/doGGn0s=";

  types-aiobotocore-gamesparks =
    buildTypesAiobotocorePackage "gamesparks" "2.7.0"
      "sha256-oVbKtuLMPpCQcZYx/cH1Dqjv/t6/uXsveflfFVqfN+8=";

  types-aiobotocore-glacier =
    buildTypesAiobotocorePackage "glacier" "2.15.0"
      "sha256-k/oPZr4TznL4ygQND0EuXCsSZNgVouBTm8Pih3m3j6k=";

  types-aiobotocore-globalaccelerator =
    buildTypesAiobotocorePackage "globalaccelerator" "2.15.0"
      "sha256-e6bP28zUjuyGn9Y+IWJyYkcRNTQ8odpK6vlZUuxSIHg=";

  types-aiobotocore-glue =
    buildTypesAiobotocorePackage "glue" "2.15.0"
      "sha256-iEi6pPUnJ1VRFXpdFhNVDf8fQ94kByVZEUzLC4SPYIQ=";

  types-aiobotocore-grafana =
    buildTypesAiobotocorePackage "grafana" "2.15.0"
      "sha256-vQJJB10LNbGNvQTj+xHVneRChhxaFZkHXel5DRg7RSs=";

  types-aiobotocore-greengrass =
    buildTypesAiobotocorePackage "greengrass" "2.15.0"
      "sha256-RDhbq/ucOitxsOeElmNV5kXGlVTHv/g2d5sxAaBzLlI=";

  types-aiobotocore-greengrassv2 =
    buildTypesAiobotocorePackage "greengrassv2" "2.15.0"
      "sha256-47eFTzMPom+q4Ha6HRjPOQCMbn9X5OtEbpScbH+JrpA=";

  types-aiobotocore-groundstation =
    buildTypesAiobotocorePackage "groundstation" "2.15.0"
      "sha256-6+KjFU7B46BL2wsXpMawQT/3DTjdVfcir/XVq1mYS0c=";

  types-aiobotocore-guardduty =
    buildTypesAiobotocorePackage "guardduty" "2.15.0"
      "sha256-IBiDqyfJYhKyqt3v3hd8y72UXawwUed3BILsswrWkmg=";

  types-aiobotocore-health =
    buildTypesAiobotocorePackage "health" "2.15.0"
      "sha256-WMgJb50/QiojGKgh6s81aKjFrewlh3bx6YWroTIZabA=";

  types-aiobotocore-healthlake =
    buildTypesAiobotocorePackage "healthlake" "2.15.0"
      "sha256-qy++uEn9Ph2Ek6Rzpth6j3x1NMK1AqoF50HFcVZBbIU=";

  types-aiobotocore-honeycode =
    buildTypesAiobotocorePackage "honeycode" "2.13.0"
      "sha256-DeeheoQeFEcDH21DSNs2kSR1rjnPLtTgz0yNCFnE+Io=";

  types-aiobotocore-iam =
    buildTypesAiobotocorePackage "iam" "2.15.0"
      "sha256-HcCuedSOhN7B4xwCH2zQz7RxrVdz6y+L7ZfNoCWG8RE=";

  types-aiobotocore-identitystore =
    buildTypesAiobotocorePackage "identitystore" "2.15.0"
      "sha256-etmeEUkNyB/I760pSt3VEqbzqKnk44Evi1zqUc1SxFI=";

  types-aiobotocore-imagebuilder =
    buildTypesAiobotocorePackage "imagebuilder" "2.15.0"
      "sha256-0jIUpv7Njy5h6vzRxnKqr0kIIiHBUkOZh+NEW1s6tLw=";

  types-aiobotocore-importexport =
    buildTypesAiobotocorePackage "importexport" "2.15.0"
      "sha256-v0gErsdr3Ljiyil8Ct7iNGqf61VenoExZOUhH760SPA=";

  types-aiobotocore-inspector =
    buildTypesAiobotocorePackage "inspector" "2.15.0"
      "sha256-HInhkpxGJ886jRhspnQDWJkRF3jmo5J1PetVNrzuS7Q=";

  types-aiobotocore-inspector2 =
    buildTypesAiobotocorePackage "inspector2" "2.15.0"
      "sha256-hvFzgJO69n+Jr5trZLv85PuActzWRXrLfRW0Iqdn9jk=";

  types-aiobotocore-internetmonitor =
    buildTypesAiobotocorePackage "internetmonitor" "2.15.0"
      "sha256-qgg/j2d763Q4e4axjkhXC3I+BnlJ24j4sZ4hxbvpgYA=";

  types-aiobotocore-iot =
    buildTypesAiobotocorePackage "iot" "2.15.0"
      "sha256-/KgXN3dWVw/ITZ51SOtJRvlUqc1kPxalRa7l7Rb6gSk=";

  types-aiobotocore-iot-data =
    buildTypesAiobotocorePackage "iot-data" "2.15.0"
      "sha256-7q+IBCltYgU5i8QuLlHm0ZFdZcDVDPLmw+tkrBSHeQQ=";

  types-aiobotocore-iot-jobs-data =
    buildTypesAiobotocorePackage "iot-jobs-data" "2.15.0"
      "sha256-aKQepzdWJBZQ+f633DVLErPldqrjyrkkAYMZt4Bi3gY=";

  types-aiobotocore-iot-roborunner =
    buildTypesAiobotocorePackage "iot-roborunner" "2.12.2"
      "sha256-O/nGvYfUibI4EvHgONtkYHFv/dZSpHCehXjietPiMJo=";

  types-aiobotocore-iot1click-devices =
    buildTypesAiobotocorePackage "iot1click-devices" "2.15.0"
      "sha256-c81lJVCAx4haFwRtRfzab8A6YKVspaUSwI9i/nd7jw8=";

  types-aiobotocore-iot1click-projects =
    buildTypesAiobotocorePackage "iot1click-projects" "2.15.0"
      "sha256-Bb9ze8VK6lRT0Ts1PhQ6jrOrjcMzYYrThqVCN4COdRw=";

  types-aiobotocore-iotanalytics =
    buildTypesAiobotocorePackage "iotanalytics" "2.15.0"
      "sha256-eOuQ4Bead3AQ4zD7Ibc/J7BO1bT3FxY0hlUB8qLz390=";

  types-aiobotocore-iotdeviceadvisor =
    buildTypesAiobotocorePackage "iotdeviceadvisor" "2.15.0"
      "sha256-vrCjbqXz1DGStxCJXwQgrQHzI7BIxGee5zolY/pU6JI=";

  types-aiobotocore-iotevents =
    buildTypesAiobotocorePackage "iotevents" "2.15.0"
      "sha256-3YScaOGMmSYRY+ObPUMWMsCJuUy6dhOYP9LNzluZnhk=";

  types-aiobotocore-iotevents-data =
    buildTypesAiobotocorePackage "iotevents-data" "2.15.0"
      "sha256-Q/i0S+Y/tbnM5buFT838rLwBKJenYcPmfwBq7pJ6pyQ=";

  types-aiobotocore-iotfleethub =
    buildTypesAiobotocorePackage "iotfleethub" "2.15.0"
      "sha256-EvUSF8PXk7Vb3+ic6ZtSdHJ63w2SmS0pp7QytP/tQss=";

  types-aiobotocore-iotfleetwise =
    buildTypesAiobotocorePackage "iotfleetwise" "2.15.0"
      "sha256-ZEWme0qNdJpQqTKit2wqMbsCa+1E+8+TaqVz/NwolSQ=";

  types-aiobotocore-iotsecuretunneling =
    buildTypesAiobotocorePackage "iotsecuretunneling" "2.15.0"
      "sha256-O48C/03s2bPB8DhN00BuwoW4gIqUnQG6Dm2I+Vs3waU=";

  types-aiobotocore-iotsitewise =
    buildTypesAiobotocorePackage "iotsitewise" "2.15.0"
      "sha256-smId9Cxm0QJ7YiORYp3FdzRNt96kFIlpnWBMbSldtYE=";

  types-aiobotocore-iotthingsgraph =
    buildTypesAiobotocorePackage "iotthingsgraph" "2.15.0"
      "sha256-cyjMATxGhhu4oYoa3l076VdgKJ2HHcrqrkGOYvAYMnE=";

  types-aiobotocore-iottwinmaker =
    buildTypesAiobotocorePackage "iottwinmaker" "2.15.0"
      "sha256-xOmpDzfMY28x5eebi6P9pzPeM0bOdaj5yYeIaMnaI9E=";

  types-aiobotocore-iotwireless =
    buildTypesAiobotocorePackage "iotwireless" "2.15.0"
      "sha256-d4Vxj2CQVXYTIPkPMF7hAi6TK3RTebuelZ+LfVCyIb8=";

  types-aiobotocore-ivs =
    buildTypesAiobotocorePackage "ivs" "2.15.0"
      "sha256-EefoDS/gNX1VkN5/5lRf4lOTHTmU0h1uZWFPiQERzvE=";

  types-aiobotocore-ivs-realtime =
    buildTypesAiobotocorePackage "ivs-realtime" "2.15.0"
      "sha256-GBan8Ln1n/ESWDNfbRlapLI5hgyamHTKQZdroasPpxo=";

  types-aiobotocore-ivschat =
    buildTypesAiobotocorePackage "ivschat" "2.15.0"
      "sha256-SE0wPCcmri42ZHBqw1zA07JHA29Zq40QAfeuGKb5cis=";

  types-aiobotocore-kafka =
    buildTypesAiobotocorePackage "kafka" "2.15.0"
      "sha256-eCQIXF+idvdZZa29cdQQbNWqDCl7YRBiL6oYooS82Xw=";

  types-aiobotocore-kafkaconnect =
    buildTypesAiobotocorePackage "kafkaconnect" "2.15.0"
      "sha256-a9/2yUk/rq0npsCyrgK/2dNWVE5qP8tqF7qpSsyT40I=";

  types-aiobotocore-kendra =
    buildTypesAiobotocorePackage "kendra" "2.15.0"
      "sha256-4xHwrD35jq9gbPR7X0TJx60GxystcHdMCuTxSZKckhw=";

  types-aiobotocore-kendra-ranking =
    buildTypesAiobotocorePackage "kendra-ranking" "2.15.0"
      "sha256-6MoK7C3eEhaty4jn6/Jc4o/WsZRTxDQ0FATrpSodTME=";

  types-aiobotocore-keyspaces =
    buildTypesAiobotocorePackage "keyspaces" "2.15.0"
      "sha256-aIjdGRxpS6bbiarTM425jE8B2xbVYKaTaiJhVSQ/4JM=";

  types-aiobotocore-kinesis =
    buildTypesAiobotocorePackage "kinesis" "2.15.0"
      "sha256-hzKV9+gFBwkIbNhlUdDrRyVFU3/VasZfyTjaZNGA0MI=";

  types-aiobotocore-kinesis-video-archived-media =
    buildTypesAiobotocorePackage "kinesis-video-archived-media" "2.15.0"
      "sha256-w2b8fP8AEH3bh3iWPym7zAmX0eyXy4hobqYXwAOs3zg=";

  types-aiobotocore-kinesis-video-media =
    buildTypesAiobotocorePackage "kinesis-video-media" "2.15.0"
      "sha256-OkF8NwJTK9doelF0LCoKivpX8IQL0gJT+WgDEi1ZhkY=";

  types-aiobotocore-kinesis-video-signaling =
    buildTypesAiobotocorePackage "kinesis-video-signaling" "2.15.0"
      "sha256-/1eZFJLoCnBbvQlSSBgwbEZRCfFdZIUbNIimTVfnxAE=";

  types-aiobotocore-kinesis-video-webrtc-storage =
    buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "2.15.0"
      "sha256-++LfFLQ6NkCs6NwMkJzZYUFvEw1iJA24NV0nq+9eMnY=";

  types-aiobotocore-kinesisanalytics =
    buildTypesAiobotocorePackage "kinesisanalytics" "2.15.0"
      "sha256-QaWFDq5DZiaqHZDOt9uat0d+YFsJymd+J+dJ8FBnsJ0=";

  types-aiobotocore-kinesisanalyticsv2 =
    buildTypesAiobotocorePackage "kinesisanalyticsv2" "2.15.0"
      "sha256-qoGXnmE2xrttERNdlD0vcgGvusymNo43Qmke53Cu9O0=";

  types-aiobotocore-kinesisvideo =
    buildTypesAiobotocorePackage "kinesisvideo" "2.15.0"
      "sha256-i5itjd7OC0MIzdV4cXYk/jKnL/fi7PqfcjBqEBxOGpU=";

  types-aiobotocore-kms =
    buildTypesAiobotocorePackage "kms" "2.15.0"
      "sha256-tNrJ8m8e1yvBxcnAFbwDPr6mLQSEYCuip/6cnIfnkYw=";

  types-aiobotocore-lakeformation =
    buildTypesAiobotocorePackage "lakeformation" "2.15.0"
      "sha256-db+t78Wdjp9Q0Yelq00j4uGO3COAq9wAQMiS04OHCDM=";

  types-aiobotocore-lambda =
    buildTypesAiobotocorePackage "lambda" "2.15.0"
      "sha256-+zVb3jcfhxcwdZInmNgI5XD8kYg+cOztM5+vKw0NQig=";

  types-aiobotocore-lex-models =
    buildTypesAiobotocorePackage "lex-models" "2.15.0"
      "sha256-CTBYSHSjk140r5/ntNrbhCW9qHyJkHKnuzDGy/VnvkA=";

  types-aiobotocore-lex-runtime =
    buildTypesAiobotocorePackage "lex-runtime" "2.15.0"
      "sha256-HTMVi8/mDsMfLYxbOa1JoOqfFGyG87k5PDy6QBCWmFo=";

  types-aiobotocore-lexv2-models =
    buildTypesAiobotocorePackage "lexv2-models" "2.15.0"
      "sha256-n+YKYwgx6LK4biiy7R0jroAniQH5eyJAZNCwt3bmd5U=";

  types-aiobotocore-lexv2-runtime =
    buildTypesAiobotocorePackage "lexv2-runtime" "2.15.0"
      "sha256-dsNybSvDpCf8WcCyLmsoNmvGyAYjOPMpaZEuT1Uon6w=";

  types-aiobotocore-license-manager =
    buildTypesAiobotocorePackage "license-manager" "2.15.0"
      "sha256-A/uBBx6+WR/QfyVSRoQ5QvxgJBoKYKomaV4Fy9bpdXs=";

  types-aiobotocore-license-manager-linux-subscriptions =
    buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "2.15.0"
      "sha256-Fsr3RTvMDVSagXHnZj2NMoqLjcVIYBGWKT5WsnIWebg=";

  types-aiobotocore-license-manager-user-subscriptions =
    buildTypesAiobotocorePackage "license-manager-user-subscriptions" "2.15.0"
      "sha256-UDxwOQm+n6wABPchWLmTFE0K1CjPiQwISmLl+7Za9w4=";

  types-aiobotocore-lightsail =
    buildTypesAiobotocorePackage "lightsail" "2.15.0"
      "sha256-iIDdWLBhFNNxtMSardWyzHL8JcvgHJIaudJ+05PXL7Q=";

  types-aiobotocore-location =
    buildTypesAiobotocorePackage "location" "2.15.0"
      "sha256-fodpQvoIPV1oTNgnSfW+3zM4AMLwe3pHVtYwZYB2kaA=";

  types-aiobotocore-logs =
    buildTypesAiobotocorePackage "logs" "2.15.0"
      "sha256-ZhbzssEml+X1laF9Cs2MegVLZ4EJCV3E4ZxLW12vEKU=";

  types-aiobotocore-lookoutequipment =
    buildTypesAiobotocorePackage "lookoutequipment" "2.15.0"
      "sha256-H2iedaGVN7uM7BLlzcnhdSbDQI96paStbohcijsRBUk=";

  types-aiobotocore-lookoutmetrics =
    buildTypesAiobotocorePackage "lookoutmetrics" "2.15.0"
      "sha256-VqVU6ziEvRtSQ60jPw2/XZo7dZTyAaLNUZ+6W9V8x+g=";

  types-aiobotocore-lookoutvision =
    buildTypesAiobotocorePackage "lookoutvision" "2.15.0"
      "sha256-7NoKEpbYPGMaaE2l8fzvE7wymcHOGy7La7sPzTWZzn8=";

  types-aiobotocore-m2 =
    buildTypesAiobotocorePackage "m2" "2.15.0"
      "sha256-oR4biBouqRzHpLi8t62eicIBAC6uDxKhHCFJXcw98VA=";

  types-aiobotocore-machinelearning =
    buildTypesAiobotocorePackage "machinelearning" "2.15.0"
      "sha256-/7OUplbaSrqFCX6FM5It2M0einbHeKdPuhlPuW1oAf0=";

  types-aiobotocore-macie =
    buildTypesAiobotocorePackage "macie" "2.7.0"
      "sha256-hJJtGsK2b56nKX1ZhiarC+ffyjHYWRiC8II4oyDZWWw=";

  types-aiobotocore-macie2 =
    buildTypesAiobotocorePackage "macie2" "2.15.0"
      "sha256-sZbckbmw1LfBLDiRjtfk2ogZe45H35vViBvr/z/syY8=";

  types-aiobotocore-managedblockchain =
    buildTypesAiobotocorePackage "managedblockchain" "2.15.0"
      "sha256-rCmVEy/oDykR2eiEZ8K1rP+M9hvie8Fr/aVXGX/mnng=";

  types-aiobotocore-managedblockchain-query =
    buildTypesAiobotocorePackage "managedblockchain-query" "2.15.0"
      "sha256-234BPfns0M64IQL6zLw2YXrEm6Gv9dr8jFZ6W9kiIFc=";

  types-aiobotocore-marketplace-catalog =
    buildTypesAiobotocorePackage "marketplace-catalog" "2.15.0"
      "sha256-xt9u8d4mUUzkieGKwsh/682O1EFplNOCvf/5RuEL9iA=";

  types-aiobotocore-marketplace-entitlement =
    buildTypesAiobotocorePackage "marketplace-entitlement" "2.15.0"
      "sha256-ZQOMPaczJfEeHHPv4GWKKrQUOBDZLBIqol4fhriAhzA=";

  types-aiobotocore-marketplacecommerceanalytics =
    buildTypesAiobotocorePackage "marketplacecommerceanalytics" "2.15.0"
      "sha256-ykZADFdCQ78IlBanzIQuWiHV5p7DuI4QPYwle1H63Bw=";

  types-aiobotocore-mediaconnect =
    buildTypesAiobotocorePackage "mediaconnect" "2.15.0"
      "sha256-Glz572WmmAhDL7s2sBNACPwSZhB3c0JzvycEZGLIMoc=";

  types-aiobotocore-mediaconvert =
    buildTypesAiobotocorePackage "mediaconvert" "2.15.0"
      "sha256-T2S8GaUePcH/bnCOFbt1Tu9Fudhv+xoBEhJX6giF2a0=";

  types-aiobotocore-medialive =
    buildTypesAiobotocorePackage "medialive" "2.15.0"
      "sha256-1pBMtaFdCzCWv2OXdP36NaeoLInFqlLTG46cSbWHihg=";

  types-aiobotocore-mediapackage =
    buildTypesAiobotocorePackage "mediapackage" "2.15.0"
      "sha256-3AQtWf67flmSz6pJ4HMzClD4qyuQUFafpGB74D8KJTA=";

  types-aiobotocore-mediapackage-vod =
    buildTypesAiobotocorePackage "mediapackage-vod" "2.15.0"
      "sha256-BPQwsGw/xXEP5SeDhIQRu376UQ9AiP7M7hy+B5j56tw=";

  types-aiobotocore-mediapackagev2 =
    buildTypesAiobotocorePackage "mediapackagev2" "2.15.0"
      "sha256-Yjr+/QxMF6E7c5jsYzjptKMzMSezcSE/u5rVqBu2nGw=";

  types-aiobotocore-mediastore =
    buildTypesAiobotocorePackage "mediastore" "2.15.0"
      "sha256-YsgTZ0j3i3nlEERkF4fLqVn5M9pkzguFqthx5XSVn1E=";

  types-aiobotocore-mediastore-data =
    buildTypesAiobotocorePackage "mediastore-data" "2.15.0"
      "sha256-ZnYZPMBhRC7e8kot/7RXCbXYGS5cU0NRfXiAdWgXVAA=";

  types-aiobotocore-mediatailor =
    buildTypesAiobotocorePackage "mediatailor" "2.15.0"
      "sha256-FjHfv8tfQVFk0iBD8np1KCQFX+BuprkIiEAUJCEDPn0=";

  types-aiobotocore-medical-imaging =
    buildTypesAiobotocorePackage "medical-imaging" "2.15.0"
      "sha256-sxbmmX7Y7NoyZzOPq3+vQFU57JrBStsWHMZig3E2ZUc=";

  types-aiobotocore-memorydb =
    buildTypesAiobotocorePackage "memorydb" "2.15.0"
      "sha256-C6dAMsCasQw2+bPFnBJVUZHdKUodT1zLKYVGizI0UiA=";

  types-aiobotocore-meteringmarketplace =
    buildTypesAiobotocorePackage "meteringmarketplace" "2.15.0"
      "sha256-UG5Wy/1Fb3JwSL9cbzegHIj/UmVDyBIW0PhovEMMtZs=";

  types-aiobotocore-mgh =
    buildTypesAiobotocorePackage "mgh" "2.15.0"
      "sha256-YGh12HkugOCGThtFOM/YGTGSsAqhkdyLXwe/DUo06JE=";

  types-aiobotocore-mgn =
    buildTypesAiobotocorePackage "mgn" "2.15.0"
      "sha256-pt+o3fHfEZ+i0nTtA3aL9N5835Z2fJPDTI27ct1Q6ts=";

  types-aiobotocore-migration-hub-refactor-spaces =
    buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "2.15.0"
      "sha256-UVbGGevpTSsk/5u4ZM4ssbupT4NNJOXRS1j6Ar6NTvg=";

  types-aiobotocore-migrationhub-config =
    buildTypesAiobotocorePackage "migrationhub-config" "2.15.0"
      "sha256-isZ/J3BH52c3kADs3QV6NCaN4U1W0SLH+2vx5FBUfYM=";

  types-aiobotocore-migrationhuborchestrator =
    buildTypesAiobotocorePackage "migrationhuborchestrator" "2.15.0"
      "sha256-21q8uRwtbfsX03ayhHNFecq8ZC/VTYZENmpWauk1oL0=";

  types-aiobotocore-migrationhubstrategy =
    buildTypesAiobotocorePackage "migrationhubstrategy" "2.15.0"
      "sha256-xXmi5qhzx4ZNTwXxAwOkPHHuMVevdjgm6ER0V/zaDf4=";

  types-aiobotocore-mobile =
    buildTypesAiobotocorePackage "mobile" "2.13.2"
      "sha256-OxB91BCAmYnY72JBWZaBlEkpAxN2Q5aY4i1Pt3eD9hc=";

  types-aiobotocore-mq =
    buildTypesAiobotocorePackage "mq" "2.15.0"
      "sha256-c/m/RAQabQHFWArEYuvEWjekBSyh+gPTHYlwNnpQ7r0=";

  types-aiobotocore-mturk =
    buildTypesAiobotocorePackage "mturk" "2.15.0"
      "sha256-vtZK0eYARSRbn9RpRK4yrKz0erx75YoFCPjuGBV2ztM=";

  types-aiobotocore-mwaa =
    buildTypesAiobotocorePackage "mwaa" "2.15.0"
      "sha256-uI+uv/D25J/bkTAS3koq7rOgGimhDhHTW2ChCk9mTP0=";

  types-aiobotocore-neptune =
    buildTypesAiobotocorePackage "neptune" "2.15.0"
      "sha256-MiH4jhgesSLxaeFzzEJfuorkAC60ncXGRfg1EFvT/Qg=";

  types-aiobotocore-network-firewall =
    buildTypesAiobotocorePackage "network-firewall" "2.15.0"
      "sha256-NLBghjcr8XbHnSaZVGxUj3jCinFZkmxagLlDMjQFCbM=";

  types-aiobotocore-networkmanager =
    buildTypesAiobotocorePackage "networkmanager" "2.15.0"
      "sha256-fA1CFdV5G+3BeJFqGb/61Mh4fDgUCIHZEHb3+Po1d70=";

  types-aiobotocore-nimble =
    buildTypesAiobotocorePackage "nimble" "2.15.0"
      "sha256-0Fp0TZK21QeaKPUQ9prOE7IaDirSGBVEgH8yv8KKy20=";

  types-aiobotocore-oam =
    buildTypesAiobotocorePackage "oam" "2.15.0"
      "sha256-1EU1ZCtMoCQaCWnSXlrayKKaC9l82y4Edc2kc2Rm/EQ=";

  types-aiobotocore-omics =
    buildTypesAiobotocorePackage "omics" "2.15.0"
      "sha256-cHrKEgGV79ea9FBdDV4fltKzEDPRsiavuSszM1z7Utw=";

  types-aiobotocore-opensearch =
    buildTypesAiobotocorePackage "opensearch" "2.15.0"
      "sha256-6S42q0i4SULwjyUEx1YCg5i1kgwz0oXC4tTFdMiG+Po=";

  types-aiobotocore-opensearchserverless =
    buildTypesAiobotocorePackage "opensearchserverless" "2.15.0"
      "sha256-o6QHCkyNfjil/O28CCYgflU6E3pUkLZ/flGYcRoIWWE=";

  types-aiobotocore-opsworks =
    buildTypesAiobotocorePackage "opsworks" "2.15.0"
      "sha256-Jg9u7P2vapI3Pwx4DFeWMTy7HriNlro0UctPhSt9TgA=";

  types-aiobotocore-opsworkscm =
    buildTypesAiobotocorePackage "opsworkscm" "2.15.0"
      "sha256-34frDYBm3pH4/YYpKey/uG0Rv6DbNCXytSV3PnR3QHw=";

  types-aiobotocore-organizations =
    buildTypesAiobotocorePackage "organizations" "2.15.0"
      "sha256-ZnjLqwh2+1N9Zb4nIkcysr+TGnUHBNxqy0vJABIQjuA=";

  types-aiobotocore-osis =
    buildTypesAiobotocorePackage "osis" "2.15.0"
      "sha256-HH7HaxV6bMywkwTsMXP3QZWc+lyWDzxtHmrZMIY/JOk=";

  types-aiobotocore-outposts =
    buildTypesAiobotocorePackage "outposts" "2.15.0"
      "sha256-kGs9VO15CkvHdSZNA0d7OGUx5Mb/nzJK0kCna9qtRIA=";

  types-aiobotocore-panorama =
    buildTypesAiobotocorePackage "panorama" "2.15.0"
      "sha256-JtO0nR0IhaCN8HNFt7YObk0ytdeirfGyXG6EFDguOxk=";

  types-aiobotocore-payment-cryptography =
    buildTypesAiobotocorePackage "payment-cryptography" "2.15.0"
      "sha256-bqRMxwiGGbMqRFZqkQnsmNq4JWuXZOvLbX51IGeUz/Q=";

  types-aiobotocore-payment-cryptography-data =
    buildTypesAiobotocorePackage "payment-cryptography-data" "2.15.0"
      "sha256-+o4Q5VmzkR9+eGUow5dlS+IyD0ukR//EQ+pbEL1v5QQ=";

  types-aiobotocore-personalize =
    buildTypesAiobotocorePackage "personalize" "2.15.0"
      "sha256-jH5M7kLBNUQAsct741zqKB5OsZyIOMLbzKi96Wem4OY=";

  types-aiobotocore-personalize-events =
    buildTypesAiobotocorePackage "personalize-events" "2.15.0"
      "sha256-KBsvNpf8J53cucgF/auehCMsMCnVxixaGMIiW9YeSvM=";

  types-aiobotocore-personalize-runtime =
    buildTypesAiobotocorePackage "personalize-runtime" "2.15.0"
      "sha256-Yf6yWHC2UqVHsxXc8ei6o6GPx8aAuhfMCkf7H/MoHzI=";

  types-aiobotocore-pi =
    buildTypesAiobotocorePackage "pi" "2.15.0"
      "sha256-Bc0f8YGFQmCybeec+SnhpWYTbGQFyt7P4WtUMc4hIuY=";

  types-aiobotocore-pinpoint =
    buildTypesAiobotocorePackage "pinpoint" "2.15.0"
      "sha256-dHJY2ErvI8iJOdoGV+7f8hlHFtcr756fNiX8MTsXhUE=";

  types-aiobotocore-pinpoint-email =
    buildTypesAiobotocorePackage "pinpoint-email" "2.15.0"
      "sha256-Dpdpfga05sbxoEiwmMwa9bYaclrrOK4HpOmqERoAYJw=";

  types-aiobotocore-pinpoint-sms-voice =
    buildTypesAiobotocorePackage "pinpoint-sms-voice" "2.15.0"
      "sha256-HAZyyUB+jpMcTwlUEJwmOxv6pTiyhWYdpbWnShVux2k=";

  types-aiobotocore-pinpoint-sms-voice-v2 =
    buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "2.15.0"
      "sha256-pI+ICkq+DyuutwMHngQYxprvQqdExaL0Fx8pDHDQ4MU=";

  types-aiobotocore-pipes =
    buildTypesAiobotocorePackage "pipes" "2.15.0"
      "sha256-MIBeZQBCCfmi6iehHD29uWX2ArGlyWA3wlTgVhBie2s=";

  types-aiobotocore-polly =
    buildTypesAiobotocorePackage "polly" "2.15.0"
      "sha256-g/MJiOG6PulfS5KpWxZqRS7eGNr83O6Q1wyoZvidXrA=";

  types-aiobotocore-pricing =
    buildTypesAiobotocorePackage "pricing" "2.15.0"
      "sha256-egYnlcrzy8pZcIALNJSsW5AFfQ5O/2vQYTupGDBvNKE=";

  types-aiobotocore-privatenetworks =
    buildTypesAiobotocorePackage "privatenetworks" "2.15.0"
      "sha256-fPrRL1QyMOvF2sg5axx6Czoa1Ad5kNs/j8MLqEh6dDE=";

  types-aiobotocore-proton =
    buildTypesAiobotocorePackage "proton" "2.15.0"
      "sha256-iJTcz8fTcBy3aw97Rn7J4m7Ha5kURK1EZvgiipqz64M=";

  types-aiobotocore-qldb =
    buildTypesAiobotocorePackage "qldb" "2.15.0"
      "sha256-TZkL/IKBAUWR0meMUTkXqCa49ea8N32Ml67y4xjUA94=";

  types-aiobotocore-qldb-session =
    buildTypesAiobotocorePackage "qldb-session" "2.15.0"
      "sha256-uLNMZgaWk9tUwYkG3vZogqyPiTbDmLcJm8GQqT3vqI4=";

  types-aiobotocore-quicksight =
    buildTypesAiobotocorePackage "quicksight" "2.15.0"
      "sha256-QWXeYC6ZVd6tBDfOWtA1zUU7z2L0GOTeSuJiOvF2nZw=";

  types-aiobotocore-ram =
    buildTypesAiobotocorePackage "ram" "2.15.0"
      "sha256-BwuU/43NqfuZt99u0BtLjOye61pyLyFm55SbGR+mcEM=";

  types-aiobotocore-rbin =
    buildTypesAiobotocorePackage "rbin" "2.15.0"
      "sha256-0TrXf6db1xP42f9eJTBnzWr7w2su8Y0ExFTWmqV73fw=";

  types-aiobotocore-rds =
    buildTypesAiobotocorePackage "rds" "2.15.0"
      "sha256-X2fN3CYSDbqk6ImaaE4oVxOZbpN/UQzp1wMAFuOq7uY=";

  types-aiobotocore-rds-data =
    buildTypesAiobotocorePackage "rds-data" "2.15.0"
      "sha256-vyi+0YaxujcmWQfm/vQaWY/iozoFTNHRkJsCqBDSby4=";

  types-aiobotocore-redshift =
    buildTypesAiobotocorePackage "redshift" "2.15.0"
      "sha256-wavvzMsczE/TJJEqcCLVm7t2QHscZuv8TS6Qsuuu990=";

  types-aiobotocore-redshift-data =
    buildTypesAiobotocorePackage "redshift-data" "2.15.0"
      "sha256-JK3ZCluyF9pReeLHZy4AjgRIJTzmabb4vYakuHIracs=";

  types-aiobotocore-redshift-serverless =
    buildTypesAiobotocorePackage "redshift-serverless" "2.15.0"
      "sha256-aw/ubbtRU1rGRnYr1j2a/WQTohYjJhBmNJ8nP9Kxk4Y=";

  types-aiobotocore-rekognition =
    buildTypesAiobotocorePackage "rekognition" "2.15.0"
      "sha256-Ptv7sgRHVfbtRIEQM/M0Di0UPIVZC79Td15H2SHyTsE=";

  types-aiobotocore-resiliencehub =
    buildTypesAiobotocorePackage "resiliencehub" "2.15.0"
      "sha256-/tJDFZQCnSvww/Mp8xL0AGhJxTmCCeI68fkvC4TSbjU=";

  types-aiobotocore-resource-explorer-2 =
    buildTypesAiobotocorePackage "resource-explorer-2" "2.15.0"
      "sha256-yF8QaebGjKkuqZKU0kkgSjXBmVpVnGdhuGG8jYi8UP0=";

  types-aiobotocore-resource-groups =
    buildTypesAiobotocorePackage "resource-groups" "2.15.0"
      "sha256-mxFaUb2cLNLaq9+pdUbfumO096kr2Ic2qGdKirR41LE=";

  types-aiobotocore-resourcegroupstaggingapi =
    buildTypesAiobotocorePackage "resourcegroupstaggingapi" "2.15.0"
      "sha256-4ISZza2xs+0qJ61oLDRI+a8PIS2Dw5ybWjmWpMzW4UQ=";

  types-aiobotocore-robomaker =
    buildTypesAiobotocorePackage "robomaker" "2.15.0"
      "sha256-8R7Sy54+dC+PlgBmZ60vI0ZC31IqPbqv6x0kM4oomlE=";

  types-aiobotocore-rolesanywhere =
    buildTypesAiobotocorePackage "rolesanywhere" "2.15.0"
      "sha256-8iyTLdJAWs9ptCUoeh9BkPQ50uCMRoT/NnKrQ8OajDc=";

  types-aiobotocore-route53 =
    buildTypesAiobotocorePackage "route53" "2.15.0"
      "sha256-UgH+fKQ+qsstCcPyvFUsG3ToMtJJCY4qlCkhMsfQfIM=";

  types-aiobotocore-route53-recovery-cluster =
    buildTypesAiobotocorePackage "route53-recovery-cluster" "2.15.0"
      "sha256-4Zt9w4r3OxoXOQH0o8nmamEWWwA36yBaAFNeX0trDk0=";

  types-aiobotocore-route53-recovery-control-config =
    buildTypesAiobotocorePackage "route53-recovery-control-config" "2.15.0"
      "sha256-z5WITGBPD7P+k33UL9rD5VLavtyXV3LAZcv0FpgC6/w=";

  types-aiobotocore-route53-recovery-readiness =
    buildTypesAiobotocorePackage "route53-recovery-readiness" "2.15.0"
      "sha256-Wc1AnMZa92WjRuc+rVePRadTSdcZfEAYOnmOyEpMaHs=";

  types-aiobotocore-route53domains =
    buildTypesAiobotocorePackage "route53domains" "2.15.0"
      "sha256-jUSEzlaMkj8Wj7VGXpIRwYHFl6n9Ei8dSgMIROtXsPo=";

  types-aiobotocore-route53resolver =
    buildTypesAiobotocorePackage "route53resolver" "2.15.0"
      "sha256-CUJK2fsYrzHtm/XOXIFY2XYflI7XS7V9p2LyLxb6Cus=";

  types-aiobotocore-rum =
    buildTypesAiobotocorePackage "rum" "2.15.0"
      "sha256-qke+xaXPd7UjBq0C1eEjw8zwjd2hpuQ/XP3FJNULKgY=";

  types-aiobotocore-s3 =
    buildTypesAiobotocorePackage "s3" "2.15.0"
      "sha256-S3ZBfYlpZqBkUNgWNirNYkwlshwEDdEJVlJ+61Gdz/c=";

  types-aiobotocore-s3control =
    buildTypesAiobotocorePackage "s3control" "2.15.0"
      "sha256-L9YP3AIR4wn4m+eG8mHrK8M+IzrVlSC1j/NMeWTLXDU=";

  types-aiobotocore-s3outposts =
    buildTypesAiobotocorePackage "s3outposts" "2.15.0"
      "sha256-CFXrxd2HOtz0Z8sz9aIXLRKRYd9louiLBfixa68l5AU=";

  types-aiobotocore-sagemaker =
    buildTypesAiobotocorePackage "sagemaker" "2.15.0"
      "sha256-hVy9kRYhnec8Q1wJDqZiSek5Ww5QmahwJRJX0V+PjmU=";

  types-aiobotocore-sagemaker-a2i-runtime =
    buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "2.15.0"
      "sha256-3jd5E8DSxushqXkIfkS9zm2s2p+iLlJfFBqCJz9STz0=";

  types-aiobotocore-sagemaker-edge =
    buildTypesAiobotocorePackage "sagemaker-edge" "2.15.0"
      "sha256-uydOAL5VEfRTL0QLl0aKIdCEjw2RYRp/RRSVMOKKsHs=";

  types-aiobotocore-sagemaker-featurestore-runtime =
    buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "2.15.0"
      "sha256-QiOGTUpL0R68Ns+Y3losMUVskv5YHf8/MnrmqeJqgmo=";

  types-aiobotocore-sagemaker-geospatial =
    buildTypesAiobotocorePackage "sagemaker-geospatial" "2.15.0"
      "sha256-oQRTnA2lbRkd1Tv7g44GdKuVuq9BZ2PXLTNWUyABKfg=";

  types-aiobotocore-sagemaker-metrics =
    buildTypesAiobotocorePackage "sagemaker-metrics" "2.15.0"
      "sha256-jzwn2HDRNL9QmSEy6V2tNTL6gcHyBXPEQnuBVISy8xY=";

  types-aiobotocore-sagemaker-runtime =
    buildTypesAiobotocorePackage "sagemaker-runtime" "2.15.0"
      "sha256-RtVl6fH1znkuNWPZ4Ndhb+qplLfDq1n1YzQ9p9Wk6G0=";

  types-aiobotocore-savingsplans =
    buildTypesAiobotocorePackage "savingsplans" "2.15.0"
      "sha256-uLmimcAk1vZO+2QlWlpV5LxTSxooYdQNsYET8CJ+tg0=";

  types-aiobotocore-scheduler =
    buildTypesAiobotocorePackage "scheduler" "2.15.0"
      "sha256-0/WvqWSd8VGISlqrTx8ef6B839PkYzDte2JYRTXwUeM=";

  types-aiobotocore-schemas =
    buildTypesAiobotocorePackage "schemas" "2.15.0"
      "sha256-+RA7DzmObfY/lbo1CCQUDMFacw/mwQGzXG8L44/y5z8=";

  types-aiobotocore-sdb =
    buildTypesAiobotocorePackage "sdb" "2.15.0"
      "sha256-ImfIS00D5p0FYZW43C6ZMz8dvSowWDavlauuTYRIBZg=";

  types-aiobotocore-secretsmanager =
    buildTypesAiobotocorePackage "secretsmanager" "2.15.0"
      "sha256-w/ngCgJP9V1i11LDIVB1mqaDc3mKhALCpHHpMjoWnL4=";

  types-aiobotocore-securityhub =
    buildTypesAiobotocorePackage "securityhub" "2.15.0"
      "sha256-EM+0L25N202Y3jLmcDz9EzfCr913N+ttbO36s0B2Cjg=";

  types-aiobotocore-securitylake =
    buildTypesAiobotocorePackage "securitylake" "2.15.0"
      "sha256-grQYAC3rSiuW8JoqJr9ESuRx0OrwukhAHZuLBdTYMoc=";

  types-aiobotocore-serverlessrepo =
    buildTypesAiobotocorePackage "serverlessrepo" "2.15.0"
      "sha256-Vvt7f6trMwQWDIC8jOs0HrkG5UB7OyDZB8QKztYPusM=";

  types-aiobotocore-service-quotas =
    buildTypesAiobotocorePackage "service-quotas" "2.15.0"
      "sha256-NVUuGzwoRUyJu5rZVkJod0BIzIt6flp7egiuM9SzXIo=";

  types-aiobotocore-servicecatalog =
    buildTypesAiobotocorePackage "servicecatalog" "2.15.0"
      "sha256-pEUUNvG0GF73VL5o3djXl6bz5UsdUV6Jlz7itavgdqc=";

  types-aiobotocore-servicecatalog-appregistry =
    buildTypesAiobotocorePackage "servicecatalog-appregistry" "2.15.0"
      "sha256-/8dE7iiNcJ5ExvzorCG1rpbvOp6HNhw3hibymr+Y+z0=";

  types-aiobotocore-servicediscovery =
    buildTypesAiobotocorePackage "servicediscovery" "2.15.0"
      "sha256-0GNZgK445MrP84a8ZlOyfhbx24EOVWcwJMlK8G0Rjqo=";

  types-aiobotocore-ses =
    buildTypesAiobotocorePackage "ses" "2.15.0"
      "sha256-df/+KPwhP26hZIHj+kB8TT0SEmzvA1sSXEAyXOOu/oQ=";

  types-aiobotocore-sesv2 =
    buildTypesAiobotocorePackage "sesv2" "2.15.0"
      "sha256-17EmuWlNJZA+zIZChhHFkPRC+doE/n+ebPqVk73VtNs=";

  types-aiobotocore-shield =
    buildTypesAiobotocorePackage "shield" "2.15.0"
      "sha256-LVdaqwMmqHeBlU++Npje5zo/y9lHkyeNFNNGaETypNk=";

  types-aiobotocore-signer =
    buildTypesAiobotocorePackage "signer" "2.15.0"
      "sha256-K0R9aAS2jacez/U5l9QIiPsBUwMDlW/bb8blBVkoolY=";

  types-aiobotocore-simspaceweaver =
    buildTypesAiobotocorePackage "simspaceweaver" "2.15.0"
      "sha256-Ilus9YxPmEpqLwuwh1GPZeDl/C7wVOUAaVi9xXRLT9E=";

  types-aiobotocore-sms =
    buildTypesAiobotocorePackage "sms" "2.15.0"
      "sha256-BniFLeuZataAM/NYyOK6iB4b2a/sWtgNRpVfgHsqYiY=";

  types-aiobotocore-sms-voice =
    buildTypesAiobotocorePackage "sms-voice" "2.15.0"
      "sha256-9MCKNyOtMOcEl/JpDNd4d9UmdJQFuxOSYVQFoRg3CL4=";

  types-aiobotocore-snow-device-management =
    buildTypesAiobotocorePackage "snow-device-management" "2.15.0"
      "sha256-ZEz4+4y7ebhBOyeYxGUrwSDeqiU2/JDMJM/3i1jqJYU=";

  types-aiobotocore-snowball =
    buildTypesAiobotocorePackage "snowball" "2.15.0"
      "sha256-WL3OEnSX9SnfAZeNzknAwCiFTxnS49M8vg4Do+qa7Es=";

  types-aiobotocore-sns =
    buildTypesAiobotocorePackage "sns" "2.15.0"
      "sha256-zoLt5UlcGqxQZY3LYzL3urQeryT/KQqmlMlMOx5UD9k=";

  types-aiobotocore-sqs =
    buildTypesAiobotocorePackage "sqs" "2.15.0"
      "sha256-pYlp0b+AowToQQsrIcOS/dA/1a49WwNbojMsWXXroxs=";

  types-aiobotocore-ssm =
    buildTypesAiobotocorePackage "ssm" "2.15.0"
      "sha256-LGuL7mGhe7XVBetPFKrwqswpyMwLO3aXuWRwuWV1n4g=";

  types-aiobotocore-ssm-contacts =
    buildTypesAiobotocorePackage "ssm-contacts" "2.15.0"
      "sha256-lycHVp5nrD6z0dXwqN5KTs7OGQwAZaAZCM5Gezqj+rQ=";

  types-aiobotocore-ssm-incidents =
    buildTypesAiobotocorePackage "ssm-incidents" "2.15.0"
      "sha256-CeSG0L3z5T+tlgrAa/dKU6knE6qKsA6B6+nJXDcgXqg=";

  types-aiobotocore-ssm-sap =
    buildTypesAiobotocorePackage "ssm-sap" "2.15.0"
      "sha256-0Dmwb0nOp3g3HY4gjxXKVRDFl/tjC1ppyzzrftgBkZU=";

  types-aiobotocore-sso =
    buildTypesAiobotocorePackage "sso" "2.15.0"
      "sha256-a9sxXz66olmSe2+PP27DFTcE9FK+ZFi7mNl3pdcOh8Q=";

  types-aiobotocore-sso-admin =
    buildTypesAiobotocorePackage "sso-admin" "2.15.0"
      "sha256-v+Co+P2VVLLF4HPES1x4gXFfq+m3EnreuD4iequsGis=";

  types-aiobotocore-sso-oidc =
    buildTypesAiobotocorePackage "sso-oidc" "2.15.0"
      "sha256-qZ0w9T/NYTvLfOQ4CwZUoNtwVFmrAH6Ow6r5Lru1Vsk=";

  types-aiobotocore-stepfunctions =
    buildTypesAiobotocorePackage "stepfunctions" "2.15.0"
      "sha256-bZPSrZ+hzxPrBYeE7PT8OGaM3V8T6950gxacsifLr0Y=";

  types-aiobotocore-storagegateway =
    buildTypesAiobotocorePackage "storagegateway" "2.15.0"
      "sha256-THc96oaV0Bh7x9H+xSsV7LD1QwJKMT8t3z2H0Qzq3lw=";

  types-aiobotocore-sts =
    buildTypesAiobotocorePackage "sts" "2.15.0"
      "sha256-ElXjKUWdOuR3xOBF59/FjWol+4v16Z5KzaGsuNL//Ng=";

  types-aiobotocore-support =
    buildTypesAiobotocorePackage "support" "2.15.0"
      "sha256-263KZcvknzGUEJYl1FX2iwqz/3OWDnE3twBwZepzFaY=";

  types-aiobotocore-support-app =
    buildTypesAiobotocorePackage "support-app" "2.15.0"
      "sha256-5YPHOgKZJADFOcefgIBg5NwolDQxDqruE3rtv3SaqJo=";

  types-aiobotocore-swf =
    buildTypesAiobotocorePackage "swf" "2.15.0"
      "sha256-7HH2Pe87MmL1huAN2G9zNf7LfdWMWMgX6zIBAxap7NU=";

  types-aiobotocore-synthetics =
    buildTypesAiobotocorePackage "synthetics" "2.15.0"
      "sha256-98S15J1C+jOv6eTO/EPEYN4qj8eWKLotMMjgpPUA5k0=";

  types-aiobotocore-textract =
    buildTypesAiobotocorePackage "textract" "2.15.0"
      "sha256-YwmAG8BMUrluE1oLDRVQ5CwfThaDnQahl2ENauOlhxw=";

  types-aiobotocore-timestream-query =
    buildTypesAiobotocorePackage "timestream-query" "2.15.0"
      "sha256-1RG3Y9yOkZh6/rySlvRzH32F5jDsw+o4UrCyiaRJZt0=";

  types-aiobotocore-timestream-write =
    buildTypesAiobotocorePackage "timestream-write" "2.15.0"
      "sha256-94yxaeKblMoFpN9UgZqR3+x65my8UHg8002tVNnWB18=";

  types-aiobotocore-tnb =
    buildTypesAiobotocorePackage "tnb" "2.15.0"
      "sha256-+5m/DzJB5y1eucLfqj3j7FyVRW4vgGxIJOfqLCs24qM=";

  types-aiobotocore-transcribe =
    buildTypesAiobotocorePackage "transcribe" "2.15.0"
      "sha256-HIFmwpEuWcvQVKHvQ9pbqrLk76J7IpH7Hd8qbm/Aopc=";

  types-aiobotocore-transfer =
    buildTypesAiobotocorePackage "transfer" "2.15.0"
      "sha256-7Hz2zgr87h5xVhkf1+UzJN+O13rPqohVN4qZ2/E8ir4=";

  types-aiobotocore-translate =
    buildTypesAiobotocorePackage "translate" "2.15.0"
      "sha256-eauTD0hzFk83sn41EnlJxrz3V1teKYQsD7ci9AhiFYc=";

  types-aiobotocore-verifiedpermissions =
    buildTypesAiobotocorePackage "verifiedpermissions" "2.15.0"
      "sha256-0MmY0RefjXcu/2cZjhR+DoLSBETiqTHO4p+O7/CsQSY=";

  types-aiobotocore-voice-id =
    buildTypesAiobotocorePackage "voice-id" "2.15.0"
      "sha256-5tsvPjGjtoXQZdYQ+NjoXcCU2F8IY/EQgEOUow+EIME=";

  types-aiobotocore-vpc-lattice =
    buildTypesAiobotocorePackage "vpc-lattice" "2.15.0"
      "sha256-Lw4kqT/JIrzK4cVsm6c1hUTTE1t6etVHfuzskO6kMyY=";

  types-aiobotocore-waf =
    buildTypesAiobotocorePackage "waf" "2.15.0"
      "sha256-syx0otSKJ896wcitfxqsJafFxf/4nokZ7pUQGiEEYTg=";

  types-aiobotocore-waf-regional =
    buildTypesAiobotocorePackage "waf-regional" "2.15.0"
      "sha256-9qIuIhKCDE6W09Ue2RFTrmKzFjK+73l6MA5X2zhoo3U=";

  types-aiobotocore-wafv2 =
    buildTypesAiobotocorePackage "wafv2" "2.15.0"
      "sha256-yeQPntqK7MRxLVqW54sihvcQ4t1MU3+sEz76N+wE0DI=";

  types-aiobotocore-wellarchitected =
    buildTypesAiobotocorePackage "wellarchitected" "2.15.0"
      "sha256-ac5AzHfMlUq9x511Dfv4abQAjMc9LFvnmfSN7neAgdM=";

  types-aiobotocore-wisdom =
    buildTypesAiobotocorePackage "wisdom" "2.15.0"
      "sha256-HYeQ/YnZYWyIs12disXzm9LM2ZA8K1KSCGyI2oPwfjA=";

  types-aiobotocore-workdocs =
    buildTypesAiobotocorePackage "workdocs" "2.15.0"
      "sha256-hue/UsRvpngLHlgFFmTIPbCXzbtFB1vCkhEkiB7TNrA=";

  types-aiobotocore-worklink =
    buildTypesAiobotocorePackage "worklink" "2.15.0"
      "sha256-m4lbQZhG7UjtgSnsPyH37K51YxohcdfRwe0jPZGqQUs=";

  types-aiobotocore-workmail =
    buildTypesAiobotocorePackage "workmail" "2.15.0"
      "sha256-vQRAXpFV6RG4HWKRHLgLOQHr++Mqly20MsTlIn2M/yA=";

  types-aiobotocore-workmailmessageflow =
    buildTypesAiobotocorePackage "workmailmessageflow" "2.15.0"
      "sha256-7iMPW/8tdqfAmcCNCcTppvzaa4zo/8NCQMIuByJVB44=";

  types-aiobotocore-workspaces =
    buildTypesAiobotocorePackage "workspaces" "2.15.0"
      "sha256-wN9Jx2vAtKsDJ9YJBJOVguEJY0OLu8OUxY/K9bRqymM=";

  types-aiobotocore-workspaces-web =
    buildTypesAiobotocorePackage "workspaces-web" "2.15.0"
      "sha256-ikKQGGpRu04WF1cix4RysjNSSl0sbA6QdPP2b2amz0E=";

  types-aiobotocore-xray =
    buildTypesAiobotocorePackage "xray" "2.15.0"
      "sha256-6axavJjQY10qnYlFnxXQvj44Dg9hmqYbpAHmTeOHoUU=";
}
