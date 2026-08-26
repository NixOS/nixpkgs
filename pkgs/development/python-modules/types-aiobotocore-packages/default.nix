{
  lib,
  stdenv,
  aiobotocore,
  boto3,
  botocore,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

let
  toUnderscore = str: builtins.replaceStrings [ "-" ] [ "_" ] str;
  buildTypesAiobotocorePackage =
    serviceName: version: hash:
    buildPythonPackage (finalAttrs: {
      pname = "types-aiobotocore-${serviceName}";
      inherit version;
      pyproject = true;

      oldStylePackages = [
        "gamesparks"
        "iot-roborunner"
        "macie"
      ];

      src = fetchPypi {
        pname =
          if builtins.elem serviceName finalAttrs.oldStylePackages then
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
      ];

      # Module has no tests
      doCheck = false;

      pythonImportsCheck = [ "types_aiobotocore_${toUnderscore serviceName}" ];

      meta = {
        description = "Type annotations for aiobotocore ${serviceName}";
        homepage = "https://github.com/youtype/mypy_boto3_builder";
        license = lib.licenses.mit;
        maintainers = [ ];
      };
    });
in
{
  types-aiobotocore-accessanalyzer =
    buildTypesAiobotocorePackage "accessanalyzer" "3.9.0"
      "sha256-MG6QpxeFraAvChkbyX/uZNiFpD/lKHyqT08iHepmAaI=";

  types-aiobotocore-account =
    buildTypesAiobotocorePackage "account" "3.9.0"
      "sha256-FfNsxg/g3L5S5Hmt6aJuonMoPC/oFtUkXJSLbtmo6Q0=";

  types-aiobotocore-acm =
    buildTypesAiobotocorePackage "acm" "3.9.0"
      "sha256-JrqvtI64fe+rZmWAUoWOa2UAs2GlT4CfaKdGRntwd5M=";

  types-aiobotocore-acm-pca =
    buildTypesAiobotocorePackage "acm-pca" "3.9.0"
      "sha256-nITmL41478u0+DvhNB/ktFl1DHIAEEs3WJVuX1vVq5g=";

  types-aiobotocore-aiops =
    buildTypesAiobotocorePackage "aiops" "3.9.0"
      "sha256-w+TkGMKzHAjwWU4fdJcAKKzaOuJeiGv32Spd07He6lw=";

  types-aiobotocore-alexaforbusiness =
    buildTypesAiobotocorePackage "alexaforbusiness" "2.13.0"
      "sha256-+w/InoQR2aZ5prieGhgEEp7auBiSSghG5zIIHY5Kyao=";

  types-aiobotocore-amp =
    buildTypesAiobotocorePackage "amp" "3.9.0"
      "sha256-cK+Ire177TLyLSyjDb87hyuLzIvg9D9O98wzpGRDwi4=";

  types-aiobotocore-amplify =
    buildTypesAiobotocorePackage "amplify" "3.9.0"
      "sha256-EgNcHHmAInaiyrFqDWT+/5gudaxbpa3suOQqV7ORzEs=";

  types-aiobotocore-amplifybackend =
    buildTypesAiobotocorePackage "amplifybackend" "3.9.0"
      "sha256-mmApCHApULR1cKbXTJILJm71Nzx1x/32j/Tf4FKcbzM=";

  types-aiobotocore-amplifyuibuilder =
    buildTypesAiobotocorePackage "amplifyuibuilder" "3.9.0"
      "sha256-zeeLz58LrKNm1+Ne9HpOho5IjsRr+cZzKakehuqW6Dk=";

  types-aiobotocore-apigateway =
    buildTypesAiobotocorePackage "apigateway" "3.9.0"
      "sha256-uLWq6aPyjOAtv5l2lEnS2TaPnVVLdUF/Z1bAFr9rhZw=";

  types-aiobotocore-apigatewaymanagementapi =
    buildTypesAiobotocorePackage "apigatewaymanagementapi" "3.9.0"
      "sha256-jxPONJ2FZdYNbdBIt2kAYCaiyeEb89HlQI8jiakv5GA=";

  types-aiobotocore-apigatewayv2 =
    buildTypesAiobotocorePackage "apigatewayv2" "3.9.0"
      "sha256-P3NwaMLkHDpE/MImdkECipaPxgCYU7vXkLKDJ8TLagE=";

  types-aiobotocore-appconfig =
    buildTypesAiobotocorePackage "appconfig" "3.9.0"
      "sha256-idAKx6VX/bO9U9Z7S0fIX+7QP9N7QePrRzWR2spSrOo=";

  types-aiobotocore-appconfigdata =
    buildTypesAiobotocorePackage "appconfigdata" "3.9.0"
      "sha256-O6xMeDngGWRQ1UK2hILa9nC18kyETBVaJ9RWJAuQnDY=";

  types-aiobotocore-appfabric =
    buildTypesAiobotocorePackage "appfabric" "3.9.0"
      "sha256-yYpmMA144fW2P9X3uoWqA76ldtE5VtmEDzGde1DMPlw=";

  types-aiobotocore-appflow =
    buildTypesAiobotocorePackage "appflow" "3.9.0"
      "sha256-i0DDWjrIV6MHFlH8y3A+fHTnQY5MUonxwIs88NVjvSg=";

  types-aiobotocore-appintegrations =
    buildTypesAiobotocorePackage "appintegrations" "3.9.0"
      "sha256-MKSvDBs4+njPOAcyOOj7zKflHWZRG1tNVgsSlZLwnf0=";

  types-aiobotocore-application-autoscaling =
    buildTypesAiobotocorePackage "application-autoscaling" "3.9.0"
      "sha256-mGJsMpJHrtVwzctrOwAVfIxmfeJcq3gju0wc/cmZ4k8=";

  types-aiobotocore-application-insights =
    buildTypesAiobotocorePackage "application-insights" "3.9.0"
      "sha256-S9EH6J9Mxzb9uPy1co5q8rOQzZ0c+Vg/tGui2wpAUcA=";

  types-aiobotocore-applicationcostprofiler =
    buildTypesAiobotocorePackage "applicationcostprofiler" "3.9.0"
      "sha256-SV5hef+c40ORZY96uDaCu3Jjt1kWXg3lzJUOPyUrVy8=";

  types-aiobotocore-appmesh =
    buildTypesAiobotocorePackage "appmesh" "3.9.0"
      "sha256-r49TJ42b5EPssoaV3g8Zzi1bqJuZ7OyYbBdK5fdSq1s=";

  types-aiobotocore-apprunner =
    buildTypesAiobotocorePackage "apprunner" "3.9.0"
      "sha256-g+UnSkDfbb7dOSAfD1pdBTxG3cQNMuJszgRVRA4RrmQ=";

  types-aiobotocore-appstream =
    buildTypesAiobotocorePackage "appstream" "3.9.0"
      "sha256-IQj4IuEu3qMTUdj0TIwspyVjyVNU3FB0/eQnyWHjFWU=";

  types-aiobotocore-appsync =
    buildTypesAiobotocorePackage "appsync" "3.9.0"
      "sha256-MQ203kvYftEzlQmhIaG/KL1O+hSgTimNu3nqJUOv69k=";

  types-aiobotocore-arc-zonal-shift =
    buildTypesAiobotocorePackage "arc-zonal-shift" "3.9.0"
      "sha256-fEDGrYyh6Hz3gCJlJR0t6uVb3L0q6owV2j/sHlJelCQ=";

  types-aiobotocore-athena =
    buildTypesAiobotocorePackage "athena" "3.9.0"
      "sha256-Rd25e5p2kgNj8C2GQQoRLX3wagGHJgZXQO3AUASbvZY=";

  types-aiobotocore-auditmanager =
    buildTypesAiobotocorePackage "auditmanager" "3.9.0"
      "sha256-VQXxLeLg3NCRwMo2Eje0vablDJF4n00+H4qvGj6tuS0=";

  types-aiobotocore-autoscaling =
    buildTypesAiobotocorePackage "autoscaling" "3.9.0"
      "sha256-o7d1nmkvVMmuKazB3oo+BvulnXS44qMOPUNvW4TBKGY=";

  types-aiobotocore-autoscaling-plans =
    buildTypesAiobotocorePackage "autoscaling-plans" "3.9.0"
      "sha256-zzeO7CbskYM6lx3wt3r4bE63HBipFaXOcNp5RMWH/mg=";

  types-aiobotocore-backup =
    buildTypesAiobotocorePackage "backup" "3.9.0"
      "sha256-o/1rlso/wh85WrUEHVjMv/uolW+dwcBRw4t60b27YEw=";

  types-aiobotocore-backup-gateway =
    buildTypesAiobotocorePackage "backup-gateway" "3.9.0"
      "sha256-Z6PgDZCJKYNx3UfPVL6lqsmUryw2hizICyhkF3MZ6r8=";

  types-aiobotocore-backupstorage =
    buildTypesAiobotocorePackage "backupstorage" "2.13.0"
      "sha256-YUKtBdBrdwL2yqDqOovvzDPbcv/sD8JLRnKz3Oh7iSU=";

  types-aiobotocore-batch =
    buildTypesAiobotocorePackage "batch" "3.9.0"
      "sha256-juWrwCLUWdGhYzW7E1TTP04Yr+LO7eiaSQdWJGtLR4U=";

  types-aiobotocore-billingconductor =
    buildTypesAiobotocorePackage "billingconductor" "3.9.0"
      "sha256-NSw9L2nm5qJrJO8kBCRSOZO7n9pk4zS+0ZHv7gXm230=";

  types-aiobotocore-braket =
    buildTypesAiobotocorePackage "braket" "3.9.0"
      "sha256-CyVjxsHiEd8rEkVFfDq/hL8S2FhfbsBz0vFogQlscFs=";

  types-aiobotocore-budgets =
    buildTypesAiobotocorePackage "budgets" "3.9.0"
      "sha256-M53ZhQn3Ybn3khzryoHLd3ZSbzglNnc7TC/A/w/R/pw=";

  types-aiobotocore-ce =
    buildTypesAiobotocorePackage "ce" "3.9.0"
      "sha256-4S/33v/Vc05i4m34lWSbRbjxSOEnSXzsQhVAD37Hm5M=";

  types-aiobotocore-chime =
    buildTypesAiobotocorePackage "chime" "3.9.0"
      "sha256-XpN17LxFgi3OzD/vicetpCG3GiVOyTRaZ08vLVLmAdA=";

  types-aiobotocore-chime-sdk-identity =
    buildTypesAiobotocorePackage "chime-sdk-identity" "3.9.0"
      "sha256-A7Iq2uwrl6fB9wf2nzO1425VjMHhUnRDNOYmE+g1ZKM=";

  types-aiobotocore-chime-sdk-media-pipelines =
    buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "3.9.0"
      "sha256-7RMD74c8q6e+HWqyO08zZG5oaoiuQ9qumiBnHniyvV0=";

  types-aiobotocore-chime-sdk-meetings =
    buildTypesAiobotocorePackage "chime-sdk-meetings" "3.9.0"
      "sha256-D+9Zl2h8ABVt8AIy2mXEXXZTO6o1PA8e+VpYA/Lt4Nw=";

  types-aiobotocore-chime-sdk-messaging =
    buildTypesAiobotocorePackage "chime-sdk-messaging" "3.9.0"
      "sha256-lydhknggsJo92AtYFtjdT+dcOItMgDuu49P/9t1BFnM=";

  types-aiobotocore-chime-sdk-voice =
    buildTypesAiobotocorePackage "chime-sdk-voice" "3.9.0"
      "sha256-RkGnAtxNmpkmYWJJT2BsYm1w/PG4lRQ9hU5hLsyzzbw=";

  types-aiobotocore-cleanrooms =
    buildTypesAiobotocorePackage "cleanrooms" "3.9.0"
      "sha256-YCU6Dkp5gpXEwJDW+9GvxBSj0bP53kHeoOpzq6Chp1c=";

  types-aiobotocore-cloud9 =
    buildTypesAiobotocorePackage "cloud9" "3.9.0"
      "sha256-4bJfxS5HTYS+Ty3P7bYZ+EOVDxEsodV93QDo7bY/ICo=";

  types-aiobotocore-cloudcontrol =
    buildTypesAiobotocorePackage "cloudcontrol" "3.9.0"
      "sha256-Gofhrbi1R0EKWKXS12yQ3uRtG4hihUKykouqiUzTYXI=";

  types-aiobotocore-clouddirectory =
    buildTypesAiobotocorePackage "clouddirectory" "3.9.0"
      "sha256-NKUvs08T3WZiLM5vSUhA2/9Vl7KlkU0bJZme9xBduo0=";

  types-aiobotocore-cloudformation =
    buildTypesAiobotocorePackage "cloudformation" "3.9.0"
      "sha256-qrBP9e3kcjo2Iw1lEnUxFqOcMipKb10e8xs8CvnsbJI=";

  types-aiobotocore-cloudfront =
    buildTypesAiobotocorePackage "cloudfront" "3.9.0"
      "sha256-loYR3kL9tAF55o4Iivlp6Egr1nzoau8Tv26d6zNbXec=";

  types-aiobotocore-cloudhsm =
    buildTypesAiobotocorePackage "cloudhsm" "3.9.0"
      "sha256-0G2JvMVAVfaY0hKyl0EIuaOphjIfuBgDdwwbEVnPjfY=";

  types-aiobotocore-cloudhsmv2 =
    buildTypesAiobotocorePackage "cloudhsmv2" "3.9.0"
      "sha256-eajNrkoKHQcOFvTdtBaOPXPqD7qtNP+dS5J3uBFVFec=";

  types-aiobotocore-cloudsearch =
    buildTypesAiobotocorePackage "cloudsearch" "3.9.0"
      "sha256-2gbpioFLBOFU+E/onySG13dYb11rifqaiW372k1t1cY=";

  types-aiobotocore-cloudsearchdomain =
    buildTypesAiobotocorePackage "cloudsearchdomain" "3.9.0"
      "sha256-0aA78BaSaoP0geIgvcv003c0uR0MiQrGNhRnD4tI1R4=";

  types-aiobotocore-cloudtrail =
    buildTypesAiobotocorePackage "cloudtrail" "3.9.0"
      "sha256-PhKeZX1q76j/zyr4cktBORmVJCPgaXYi3eM4HtI9/nE=";

  types-aiobotocore-cloudtrail-data =
    buildTypesAiobotocorePackage "cloudtrail-data" "3.9.0"
      "sha256-HaV4kNwpBoYyxhjklX1pFyinPLC1l8EZgy3d3HM/N90=";

  types-aiobotocore-cloudwatch =
    buildTypesAiobotocorePackage "cloudwatch" "3.9.0"
      "sha256-Gn2nP4hpryntj46uCyKOdj3FcrT0qEKLYSlxlYF0J7I=";

  types-aiobotocore-codeartifact =
    buildTypesAiobotocorePackage "codeartifact" "3.9.0"
      "sha256-GB7TZI+P6MDlfEX91sQBnfhgPNcBFnRn68lSIdujShc=";

  types-aiobotocore-codebuild =
    buildTypesAiobotocorePackage "codebuild" "3.9.0"
      "sha256-aBmGXRuaXT3UKpjlPEnE61vPyCD4vnvN2S8AQIUFKwk=";

  types-aiobotocore-codecatalyst =
    buildTypesAiobotocorePackage "codecatalyst" "3.9.0"
      "sha256-yIX7D4hFfZ1Lea9teahI9yt8f7DLpdgfPApqR9nRJDM=";

  types-aiobotocore-codecommit =
    buildTypesAiobotocorePackage "codecommit" "3.9.0"
      "sha256-AOoWsWofEWDiyJIby4Km7S21RzuhFdHvnflv3Wba4FY=";

  types-aiobotocore-codeconnections =
    buildTypesAiobotocorePackage "codeconnections" "3.9.0"
      "sha256-4AoRHoTqvJY8y5X6NNWeu0sJFoJ4+VJeHqiIJEWNCEI=";

  types-aiobotocore-codedeploy =
    buildTypesAiobotocorePackage "codedeploy" "3.9.0"
      "sha256-PJ/B0FEd2y+HTIaKgm+o3nJmFl4IaZvaNvT33rCDqUk=";

  types-aiobotocore-codeguru-reviewer =
    buildTypesAiobotocorePackage "codeguru-reviewer" "3.9.0"
      "sha256-cbrI3F/w5VsIhlbTjf6fazwLdBSO7EKVXfxf50tQH+o=";

  types-aiobotocore-codeguru-security =
    buildTypesAiobotocorePackage "codeguru-security" "3.9.0"
      "sha256-RNRheQTEweSk427cJh2YYawRIlFzM03zYyrqLXvfkJA=";

  types-aiobotocore-codeguruprofiler =
    buildTypesAiobotocorePackage "codeguruprofiler" "3.9.0"
      "sha256-6qZk620M2tMVZst75Ck90EGL8SR1H3sMOhUIxrCiUm8=";

  types-aiobotocore-codepipeline =
    buildTypesAiobotocorePackage "codepipeline" "3.9.0"
      "sha256-fDHRL/aFBjrekmlKGpJS6kTExOIIl71/7Mk6FYGhr1Q=";

  types-aiobotocore-codestar =
    buildTypesAiobotocorePackage "codestar" "2.13.3"
      "sha256-Z1ewx2RjmxbOQZ7wXaN54PVOuRs6LP3rMpsrVTacwjo=";

  types-aiobotocore-codestar-connections =
    buildTypesAiobotocorePackage "codestar-connections" "3.9.0"
      "sha256-rNgT2uaRF76bo8zQfU793XtXb2v0nNJtu3ifnQSdCg0=";

  types-aiobotocore-codestar-notifications =
    buildTypesAiobotocorePackage "codestar-notifications" "3.9.0"
      "sha256-26etCnVZOQXQzgJZ5VyCyP7tCstZXkE3+qoGVNy+uhk=";

  types-aiobotocore-cognito-identity =
    buildTypesAiobotocorePackage "cognito-identity" "3.9.0"
      "sha256-9XqwWYJ2tVJaR7MrGiT2X9Nc7xIcj5VM+9JqTk/tyTs=";

  types-aiobotocore-cognito-idp =
    buildTypesAiobotocorePackage "cognito-idp" "3.9.0"
      "sha256-2CHWrdiWO8eai8LG+Dl6AW26A0zxUupVe/7c1Fp2LmA=";

  types-aiobotocore-cognito-sync =
    buildTypesAiobotocorePackage "cognito-sync" "3.9.0"
      "sha256-zXr5PrKKCInma692cIFToKsrKNPerOlFE3rTBUFeYX0=";

  types-aiobotocore-comprehend =
    buildTypesAiobotocorePackage "comprehend" "3.9.0"
      "sha256-RooE1CsMD7LcIdT5tQ05tYIzEwLnYHhq6bJ10ljZu7Q=";

  types-aiobotocore-comprehendmedical =
    buildTypesAiobotocorePackage "comprehendmedical" "3.9.0"
      "sha256-zWnLiZPTY0vTNrd6YfL8NZd7YGFiyk0DCPj0ciQcAxY=";

  types-aiobotocore-compute-optimizer =
    buildTypesAiobotocorePackage "compute-optimizer" "3.9.0"
      "sha256-9pnAIEhWYoZ8w+IA7mLsInoDygNRbUTUPpwrXE++WOc=";

  types-aiobotocore-config =
    buildTypesAiobotocorePackage "config" "3.9.0"
      "sha256-aW/DmC05qsPnHJEtCKM/uHJfhXdeYmsrLJ7VVGSw3Iw=";

  types-aiobotocore-connect =
    buildTypesAiobotocorePackage "connect" "3.9.0"
      "sha256-ltHwIktrZD2aNitkOjVVO5ODI0hGXwZkW9QiYQ8GY28=";

  types-aiobotocore-connect-contact-lens =
    buildTypesAiobotocorePackage "connect-contact-lens" "3.9.0"
      "sha256-BiiPALjY9fNzfoXdvjEMgma/itzR2Y2u+xkJdjC31fU=";

  types-aiobotocore-connectcampaigns =
    buildTypesAiobotocorePackage "connectcampaigns" "3.9.0"
      "sha256-Lp5nWVhrplJ+9F7lL0aME24gl5aiSrFAYjoknImKzhc=";

  types-aiobotocore-connectcases =
    buildTypesAiobotocorePackage "connectcases" "3.9.0"
      "sha256-D9Sx40YL+cwMCbu1SodfnND+tOzSFZrB4SlTChDYykw=";

  types-aiobotocore-connectparticipant =
    buildTypesAiobotocorePackage "connectparticipant" "3.9.0"
      "sha256-2vJKirnI2uXuggPDW2kKuQdbhbOrj+JveLmUu5nVWmw=";

  types-aiobotocore-controltower =
    buildTypesAiobotocorePackage "controltower" "3.9.0"
      "sha256-/U+o+Pqj6J9V2HLhd5OeutAQyoGSU0i0VMjH6tPaD9E=";

  types-aiobotocore-cur =
    buildTypesAiobotocorePackage "cur" "3.9.0"
      "sha256-fk20LbWiOicEwcbGAtgZXyDOOFF5HUGlcaT/jK7gwKg=";

  types-aiobotocore-customer-profiles =
    buildTypesAiobotocorePackage "customer-profiles" "3.9.0"
      "sha256-7lYgapnIOzrHsH1h1R5llLnXKD8RlELDeuz3lw/FIR8=";

  types-aiobotocore-databrew =
    buildTypesAiobotocorePackage "databrew" "3.9.0"
      "sha256-D48Iz/NwsSLMy0INgcp19uQUE1IMIy3nmEyq0mznbso=";

  types-aiobotocore-dataexchange =
    buildTypesAiobotocorePackage "dataexchange" "3.9.0"
      "sha256-kS3ts9NLzwD4ScSVzFQhUyL7CkzIBcNsE1PbopHUrLs=";

  types-aiobotocore-datapipeline =
    buildTypesAiobotocorePackage "datapipeline" "3.9.0"
      "sha256-Y38cyaE4YK9fOajJcggeUE6jjufXbc0sabz3aWyqNIE=";

  types-aiobotocore-datasync =
    buildTypesAiobotocorePackage "datasync" "3.9.0"
      "sha256-msI8qXnDs1ayFuRAf+HDyX88G+0mQbrENBxhndSELOM=";

  types-aiobotocore-dax =
    buildTypesAiobotocorePackage "dax" "3.9.0"
      "sha256-RyW494BD2gsvHiWheQ+UxYp/R9YNVLmKsL7wwl2Lexo=";

  types-aiobotocore-detective =
    buildTypesAiobotocorePackage "detective" "3.9.0"
      "sha256-UCtNZZTGFhpFNqnK5scCCFtmV0rqIMwEtOoC1Bwa78A=";

  types-aiobotocore-devicefarm =
    buildTypesAiobotocorePackage "devicefarm" "3.9.0"
      "sha256-nVv0imSlBHfJ/fvG1FDGzhAx9/e4231YqaLfAhvQkGY=";

  types-aiobotocore-devops-guru =
    buildTypesAiobotocorePackage "devops-guru" "3.9.0"
      "sha256-18b4v55qRDlk2skPHhzRoYL7tp+cW/IMVf/nY7LmKhc=";

  types-aiobotocore-directconnect =
    buildTypesAiobotocorePackage "directconnect" "3.9.0"
      "sha256-xND/8Ft/fbQ/B6SmHN4aO7E3TuAgeNvghzzrviz9ITc=";

  types-aiobotocore-discovery =
    buildTypesAiobotocorePackage "discovery" "3.9.0"
      "sha256-Gxw6giv4SOGInJ/fxnELl2oEND7MBZ/SN18a8zfRjL0=";

  types-aiobotocore-dlm =
    buildTypesAiobotocorePackage "dlm" "3.9.0"
      "sha256-y4s21xgGTIqEO39kkoTwOLD6Rcr8ur3hMQvvpgiPd8I=";

  types-aiobotocore-dms =
    buildTypesAiobotocorePackage "dms" "3.9.0"
      "sha256-vHvEfDDWKRgb5502Wnt0S3YHpS2viCUazXgCqu35juM=";

  types-aiobotocore-docdb =
    buildTypesAiobotocorePackage "docdb" "3.9.0"
      "sha256-kH7u3UMqICXeDCmz1Ngo2CyKtlSzQrWWAnYC21WXpA4=";

  types-aiobotocore-docdb-elastic =
    buildTypesAiobotocorePackage "docdb-elastic" "3.9.0"
      "sha256-8QETkqqZSxoe+OV76mIH8sStLUn4TkhUoJ4NeNM54Zs=";

  types-aiobotocore-drs =
    buildTypesAiobotocorePackage "drs" "3.9.0"
      "sha256-MVkb9tJ+3GP3P3UeOl41CDBUyLNZjDwFZY6lZEixagU=";

  types-aiobotocore-ds =
    buildTypesAiobotocorePackage "ds" "3.9.0"
      "sha256-2kIhHM7wdW44rmPj4s8QGGXlHTUj+WbAy3osnRZInSM=";

  types-aiobotocore-dynamodb =
    buildTypesAiobotocorePackage "dynamodb" "3.9.0"
      "sha256-aALTKfgG32ve8ljTFbF80J4U5t2ZEB2uML5sU48cqhc=";

  types-aiobotocore-dynamodbstreams =
    buildTypesAiobotocorePackage "dynamodbstreams" "3.9.0"
      "sha256-RNDfgnXuOOepGuVso98CCdI+d9vYDk0hKUBDGd9f+bM=";

  types-aiobotocore-ebs =
    buildTypesAiobotocorePackage "ebs" "3.9.0"
      "sha256-myUROkbHdvQEZvWC/y3A+GIs4PMGKvzoz68jav0Gl9c=";

  types-aiobotocore-ec2 =
    buildTypesAiobotocorePackage "ec2" "3.9.0"
      "sha256-6awN5pf5Aw3P6yzktjoW+hiWNPH6GPOq+3rrqOa3QX0=";

  types-aiobotocore-ec2-instance-connect =
    buildTypesAiobotocorePackage "ec2-instance-connect" "3.9.0"
      "sha256-IMyAnVVWUBTAMXWKPfpveopYpCrtn93m2Ffp+p3+euY=";

  types-aiobotocore-ecr =
    buildTypesAiobotocorePackage "ecr" "3.9.0"
      "sha256-74g3Bn4hw6n2leDpw8ad8G4iHcMGQXcHcFnFqdVFyto=";

  types-aiobotocore-ecr-public =
    buildTypesAiobotocorePackage "ecr-public" "3.9.0"
      "sha256-WUnSvy3Vz+6KsixV+gFp3S+69bDK8m9uDs208CgACdo=";

  types-aiobotocore-ecs =
    buildTypesAiobotocorePackage "ecs" "3.9.0"
      "sha256-Vbky8guVQ2y/x1YwfBPMsL9mp/J7sxtMNBjFmKRXS+Y=";

  types-aiobotocore-efs =
    buildTypesAiobotocorePackage "efs" "3.9.0"
      "sha256-yvrG3LS2jgEB8oIm9Heq1mnOR3XBqnDPeLy7V1vnQ5Q=";

  types-aiobotocore-eks =
    buildTypesAiobotocorePackage "eks" "3.9.0"
      "sha256-1fQA/22xGpSxm8jOSNBV2mhnWajag8UxOi2OV4NQc9Q=";

  types-aiobotocore-elastic-inference =
    buildTypesAiobotocorePackage "elastic-inference" "2.20.0"
      "sha256-jFSY7JBVjDQi6dCqlX2LG7jxpSKfILv3XWbYidvtGos=";

  types-aiobotocore-elasticache =
    buildTypesAiobotocorePackage "elasticache" "3.9.0"
      "sha256-V2nddM/Cs+s9Hx/g3pERAXO3zCOU4B8j9PSDJlptotk=";

  types-aiobotocore-elasticbeanstalk =
    buildTypesAiobotocorePackage "elasticbeanstalk" "3.9.0"
      "sha256-yfoOTS7tylyDELn7juKcJlhwKsEPM0Kaw3yDOk0+cFo=";

  types-aiobotocore-elastictranscoder =
    buildTypesAiobotocorePackage "elastictranscoder" "2.25.2"
      "sha256-5t214U60d2kSf8bmUiEkj4OMFf3+SbNRGqLif1Rj28E=";

  types-aiobotocore-elb =
    buildTypesAiobotocorePackage "elb" "3.9.0"
      "sha256-MzDmw2U3QiHQqBmqTDdjesHL09ES4G8c00qlnU8azmI=";

  types-aiobotocore-elbv2 =
    buildTypesAiobotocorePackage "elbv2" "3.9.0"
      "sha256-mQcnV1leD1+iVch44Am97U9y8Zt1aytblLtq+ai/6HE=";

  types-aiobotocore-emr =
    buildTypesAiobotocorePackage "emr" "3.9.0"
      "sha256-7GKll1M9f9BO2i/SgJQl+nBI5KBY1Rq7p9+yhSs2XlE=";

  types-aiobotocore-emr-containers =
    buildTypesAiobotocorePackage "emr-containers" "3.9.0"
      "sha256-1jEkpoccpe5egKFuPgCkO8e90q7wIHCwYHrSuqfwLIY=";

  types-aiobotocore-emr-serverless =
    buildTypesAiobotocorePackage "emr-serverless" "3.9.0"
      "sha256-1YJOadDvyvxs3ltJyEJvHmYafBqD76ze56l4Za8pN+8=";

  types-aiobotocore-entityresolution =
    buildTypesAiobotocorePackage "entityresolution" "3.9.0"
      "sha256-1W3aZEvoVtig00KvQWMUK8NH0eulu1OqhDYwrnmaZpw=";

  types-aiobotocore-es =
    buildTypesAiobotocorePackage "es" "3.9.0"
      "sha256-FS6AJ4LG4PHqy3jS9QApJay1Loek7FElnxH11ayTzIU=";

  types-aiobotocore-events =
    buildTypesAiobotocorePackage "events" "3.9.0"
      "sha256-O9ncUz2L6B/0LKcLI+dL82o06h/9jLQ4V121dX36DuQ=";

  types-aiobotocore-evidently =
    buildTypesAiobotocorePackage "evidently" "3.1.1"
      "sha256-g+XQEgqqZul8kOg0kstdYMvw2tu6zhC9GZGgs7WH3Mo=";

  types-aiobotocore-finspace =
    buildTypesAiobotocorePackage "finspace" "3.9.0"
      "sha256-dpdEOVQaTBsbAZfi7JMekzchm4TRj8k/obDA+la5LHk=";

  types-aiobotocore-finspace-data =
    buildTypesAiobotocorePackage "finspace-data" "3.9.0"
      "sha256-tS0AJgQWC3vJRpGdYDI+m2GcfL+DMGyrtsJrtaBbC+0=";

  types-aiobotocore-firehose =
    buildTypesAiobotocorePackage "firehose" "3.9.0"
      "sha256-eAMurPOJLRwT7TA/v2Tf6kUluN9gYRS5yIa7p2ONB38=";

  types-aiobotocore-fis =
    buildTypesAiobotocorePackage "fis" "3.9.0"
      "sha256-aUgMxlOUQ3e8UktpEy9Sw4v/0/FedEhARDVf68oScgA=";

  types-aiobotocore-fms =
    buildTypesAiobotocorePackage "fms" "3.9.0"
      "sha256-RpwOFlqGO2MG+dA6vjVX+WTiJ5BTR4vAnzIK0naQdGA=";

  types-aiobotocore-forecast =
    buildTypesAiobotocorePackage "forecast" "3.9.0"
      "sha256-iCMMO03/X2tK9eAHdbUE1A0Dpop0ROSV+ZwrOMXm7xo=";

  types-aiobotocore-forecastquery =
    buildTypesAiobotocorePackage "forecastquery" "3.9.0"
      "sha256-Vo0YLe6eEmnRXlUL4A/fuKrYvbhWkyYP/AVPLwxQ/Jw=";

  types-aiobotocore-frauddetector =
    buildTypesAiobotocorePackage "frauddetector" "3.9.0"
      "sha256-FNkE2/daZGgiudsaE+kPnxCV7pzcbemwAA7wmY1EIEQ=";

  types-aiobotocore-freetier =
    buildTypesAiobotocorePackage "freetier" "3.9.0"
      "sha256-Hhv+Aq+JSwcw23Dk1H0NQ6GbtxLbjOHmSrZRv/pwI9M=";

  types-aiobotocore-fsx =
    buildTypesAiobotocorePackage "fsx" "3.9.0"
      "sha256-vnrIy+0usKKxJMJKB12gOyDpOw3PTK0CvWY/PgBdh64=";

  types-aiobotocore-gamelift =
    buildTypesAiobotocorePackage "gamelift" "3.9.0"
      "sha256-MaHrHthJJgpIg3aw9kBQJmcgndTbf1rN27XqnxY0OG4=";

  types-aiobotocore-gamesparks =
    buildTypesAiobotocorePackage "gamesparks" "2.7.0"
      "sha256-oVbKtuLMPpCQcZYx/cH1Dqjv/t6/uXsveflfFVqfN+8=";

  types-aiobotocore-glacier =
    buildTypesAiobotocorePackage "glacier" "3.9.0"
      "sha256-hEABC8hRzvzvLzbM427Hc1FtAuLMcLJlEIHlQ7zmCK4=";

  types-aiobotocore-globalaccelerator =
    buildTypesAiobotocorePackage "globalaccelerator" "3.9.0"
      "sha256-T+7BNdAv7V5wt+kxJi2bHpbqoszjx4gBj6duZnv+cRI=";

  types-aiobotocore-glue =
    buildTypesAiobotocorePackage "glue" "3.9.0"
      "sha256-hTnkuSmzQUFbtcsYxjmx0hT/ODx3+mXE3ldFnqZlans=";

  types-aiobotocore-grafana =
    buildTypesAiobotocorePackage "grafana" "3.9.0"
      "sha256-OPr/p5fDjLem83IkkDneXQBdl7wsBMxvRdCy4bYd/e4=";

  types-aiobotocore-greengrass =
    buildTypesAiobotocorePackage "greengrass" "3.9.0"
      "sha256-xqz0k61h/0GZWbK27qkrje55cRdCVE7BXDjWkGFdx6o=";

  types-aiobotocore-greengrassv2 =
    buildTypesAiobotocorePackage "greengrassv2" "3.9.0"
      "sha256-3cpC4azBtfDekqPCDIGuKmfGT8v32g0JuXnhrAfb9l8=";

  types-aiobotocore-groundstation =
    buildTypesAiobotocorePackage "groundstation" "3.9.0"
      "sha256-MVQM6fJGguaxHvkxHpo/0SavQlgZyY3Bc6VLIHZ5JRE=";

  types-aiobotocore-guardduty =
    buildTypesAiobotocorePackage "guardduty" "3.9.0"
      "sha256-m6wF9oGFeKw3Ee1goF+Qa9QcxYRNY7KmGyDk3L9BZjI=";

  types-aiobotocore-health =
    buildTypesAiobotocorePackage "health" "3.9.0"
      "sha256-2KuJt+GXMUglP7DxPJhkgEB3EBHOIbkoMtH9wwxCIGk=";

  types-aiobotocore-healthlake =
    buildTypesAiobotocorePackage "healthlake" "3.9.0"
      "sha256-e+VEjiolrlmUqA6ljkSzjtYoeWYxkGYYlq6WCboo5oI=";

  types-aiobotocore-honeycode =
    buildTypesAiobotocorePackage "honeycode" "2.13.0"
      "sha256-DeeheoQeFEcDH21DSNs2kSR1rjnPLtTgz0yNCFnE+Io=";

  types-aiobotocore-iam =
    buildTypesAiobotocorePackage "iam" "3.9.0"
      "sha256-7yXQEyDvYCrURlIvPUe+NR96G41QvWn+Ql07IeT0Fm0=";

  types-aiobotocore-identitystore =
    buildTypesAiobotocorePackage "identitystore" "3.9.0"
      "sha256-BvEDMKQrfL7cQCFeV2Wv3Q8MOwdgXxC16vCGysyznJY=";

  types-aiobotocore-imagebuilder =
    buildTypesAiobotocorePackage "imagebuilder" "3.9.0"
      "sha256-aOAzaLaIX7d/7+OUb45mB+83Owht/DQVvkLEzIeGpG8=";

  types-aiobotocore-importexport =
    buildTypesAiobotocorePackage "importexport" "3.9.0"
      "sha256-xBEQMDNMxPCoiposjxfHH7bdXO3e12YHAPY7t1UKuYI=";

  types-aiobotocore-inspector =
    buildTypesAiobotocorePackage "inspector" "3.9.0"
      "sha256-WkzgYdAvyUeItxY1Q3NRh7QcAqkxBBAZh/daZkatm/g=";

  types-aiobotocore-inspector2 =
    buildTypesAiobotocorePackage "inspector2" "3.9.0"
      "sha256-adm1zSrC1oz2knWwTZs9UVtaivrWhjCVvzi5ZT7sBC0=";

  types-aiobotocore-internetmonitor =
    buildTypesAiobotocorePackage "internetmonitor" "3.9.0"
      "sha256-9RcAmkf0Qde9cLGWryEyAsCSZnpLPYkXAhsZEALkfoQ=";

  types-aiobotocore-iot =
    buildTypesAiobotocorePackage "iot" "3.9.0"
      "sha256-Tj2j7ZVVTLfUDCoDcGYrjmN1+6W8xDoZzPzK04pRbUY=";

  types-aiobotocore-iot-data =
    buildTypesAiobotocorePackage "iot-data" "3.9.0"
      "sha256-MsxN61uocwQRUlvE8abR4JjfvldIfiqJK0D3ANSf69c=";

  types-aiobotocore-iot-jobs-data =
    buildTypesAiobotocorePackage "iot-jobs-data" "3.9.0"
      "sha256-ySeBz7/qGC3mhimp70knzF3YrDpYdYnsF7a7jqJD3RM=";

  types-aiobotocore-iot-roborunner =
    buildTypesAiobotocorePackage "iot-roborunner" "2.12.2"
      "sha256-O/nGvYfUibI4EvHgONtkYHFv/dZSpHCehXjietPiMJo=";

  types-aiobotocore-iot1click-devices =
    buildTypesAiobotocorePackage "iot1click-devices" "2.16.1"
      "sha256-gnQZJMw+Q37B3qu1eYDNxYdEyxNRRZlqAsa4OgZbb40=";

  types-aiobotocore-iot1click-projects =
    buildTypesAiobotocorePackage "iot1click-projects" "2.16.1"
      "sha256-qK5dPunPAbC7xIramYINSda50Zum6yQ4n2BfuOgLC58=";

  types-aiobotocore-iotanalytics =
    buildTypesAiobotocorePackage "iotanalytics" "3.1.1"
      "sha256-Yf1vvasgtUxFiEfSrlPq0Q2yhbAOGyRATzid+qYjlj8=";

  types-aiobotocore-iotdeviceadvisor =
    buildTypesAiobotocorePackage "iotdeviceadvisor" "3.9.0"
      "sha256-EIEqNPreIbWxX0sZuz36xoZk3cLNjdOw++8u8CpRStQ=";

  types-aiobotocore-iotevents =
    buildTypesAiobotocorePackage "iotevents" "3.7.0"
      "sha256-isYjEnViFGsgtRDb3Y2i9vTCjqDcB88rM8JmxhpxIII=";

  types-aiobotocore-iotevents-data =
    buildTypesAiobotocorePackage "iotevents-data" "3.7.0"
      "sha256-FZZowHBNWFF3pWDNZIG12vR9NbWfWNWxt+IJvZYlp3Y=";

  types-aiobotocore-iotfleethub =
    buildTypesAiobotocorePackage "iotfleethub" "2.24.2"
      "sha256-WzdCGMVRCl8x+UswlyApMYMYT3Rvtng0ID2YyV08NzA=";

  types-aiobotocore-iotfleetwise =
    buildTypesAiobotocorePackage "iotfleetwise" "3.9.0"
      "sha256-qaznIJlkBQKvGegXw1Y0+aGmgcrMpOp+d7O9IQvM3hU=";

  types-aiobotocore-iotsecuretunneling =
    buildTypesAiobotocorePackage "iotsecuretunneling" "3.9.0"
      "sha256-gHbqrTjY0xkwCBa0vJNgdNf5irEvPHQwAKOvzx3JPdw=";

  types-aiobotocore-iotsitewise =
    buildTypesAiobotocorePackage "iotsitewise" "3.9.0"
      "sha256-1AJeyA1oQoddEgTnHgnRQV+5TQtFRjv1Am1gyiQicVs=";

  types-aiobotocore-iotthingsgraph =
    buildTypesAiobotocorePackage "iotthingsgraph" "3.9.0"
      "sha256-dUR+U9v2kzCGzlGQxvLV3j69ap8wEZJwcfrSoXVAj1s=";

  types-aiobotocore-iottwinmaker =
    buildTypesAiobotocorePackage "iottwinmaker" "3.9.0"
      "sha256-gpMSd++owsr408IM5xLuoDSc5fL6pTFaBCBjKJAcE8s=";

  types-aiobotocore-iotwireless =
    buildTypesAiobotocorePackage "iotwireless" "3.9.0"
      "sha256-l5Lll8LUpatGYUzDelb7qrd5uMZL/bVxEhSQ9Hgv0Iw=";

  types-aiobotocore-ivs =
    buildTypesAiobotocorePackage "ivs" "3.9.0"
      "sha256-LlucdJiPuk/u3bzpthgKZgB6iiojESpMkq49Lic8/Co=";

  types-aiobotocore-ivs-realtime =
    buildTypesAiobotocorePackage "ivs-realtime" "3.9.0"
      "sha256-l3Wl/oFgaZBdd4fofBSY4aUUu8BmxYiepVUBE7HIA7s=";

  types-aiobotocore-ivschat =
    buildTypesAiobotocorePackage "ivschat" "3.9.0"
      "sha256-sXMRPEfVwzAjlcodGQrymeXsJ9jFu6mmfWTX5lYkvIY=";

  types-aiobotocore-kafka =
    buildTypesAiobotocorePackage "kafka" "3.9.0"
      "sha256-cCzaLcGdEwNISnnUal4RsV4h8oM7hKUdqD2jmYPE5hI=";

  types-aiobotocore-kafkaconnect =
    buildTypesAiobotocorePackage "kafkaconnect" "3.9.0"
      "sha256-OkEQUrI5aP9u4TUKFtw8VEZsfwLqYgtvH/8cjg5pqg4=";

  types-aiobotocore-kendra =
    buildTypesAiobotocorePackage "kendra" "3.9.0"
      "sha256-5ik/+OONTyatEvqV7SzbdGShdoUkxlx1B1WJuv/aM4A=";

  types-aiobotocore-kendra-ranking =
    buildTypesAiobotocorePackage "kendra-ranking" "3.9.0"
      "sha256-EVFQe7Rms6H56DZofAGzLY5FtM6friTQTLjCUeLTyLI=";

  types-aiobotocore-keyspaces =
    buildTypesAiobotocorePackage "keyspaces" "3.9.0"
      "sha256-HvmzpiRT82tzf3U8WdTSC+ZvOVRRUAdmg51+ZQMesgo=";

  types-aiobotocore-kinesis =
    buildTypesAiobotocorePackage "kinesis" "3.9.0"
      "sha256-7K8d6/Vk2Ie7jvnLsodvYuBku95Sv1mfxKFA8S7pvc8=";

  types-aiobotocore-kinesis-video-archived-media =
    buildTypesAiobotocorePackage "kinesis-video-archived-media" "3.9.0"
      "sha256-uJeJyKdmjULeZwKYvqaLndlG2gJ8yTje4FyGVbBRCSg=";

  types-aiobotocore-kinesis-video-media =
    buildTypesAiobotocorePackage "kinesis-video-media" "3.9.0"
      "sha256-C01287QCPRBwu2tBnENGCQ4akxHkH5aj/vYryhaW184=";

  types-aiobotocore-kinesis-video-signaling =
    buildTypesAiobotocorePackage "kinesis-video-signaling" "3.9.0"
      "sha256-HTeni7lfL136lkjWrwcauroZOX/cXHuCJik+as1agJc=";

  types-aiobotocore-kinesis-video-webrtc-storage =
    buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "3.9.0"
      "sha256-86U0WHkvlC04jrfblkIlj58dyIaKvXmfvLuk51s0P4g=";

  types-aiobotocore-kinesisanalytics =
    buildTypesAiobotocorePackage "kinesisanalytics" "3.9.0"
      "sha256-LXZaluWKfIUhgR9FQ4T6u9o9Lmc+k7WCwksVnfSCzso=";

  types-aiobotocore-kinesisanalyticsv2 =
    buildTypesAiobotocorePackage "kinesisanalyticsv2" "3.9.0"
      "sha256-bEa0TURbK1amjGfRl7lDpAIiN+lTHXN+KDfgweTtYlI=";

  types-aiobotocore-kinesisvideo =
    buildTypesAiobotocorePackage "kinesisvideo" "3.9.0"
      "sha256-3LdK5NLjnz8g5EZJmw6gH0yAvfNhU+UezZ8z4iJtFOA=";

  types-aiobotocore-kms =
    buildTypesAiobotocorePackage "kms" "3.9.0"
      "sha256-k59k1hBIG3BHZmapfnndkxJRrhDxvVclcC1OLoots7E=";

  types-aiobotocore-lakeformation =
    buildTypesAiobotocorePackage "lakeformation" "3.9.0"
      "sha256-jsKyKKis3xekXzzUvIl4z1CYr3jbGOoE0AliKUE4TFo=";

  types-aiobotocore-lambda =
    buildTypesAiobotocorePackage "lambda" "3.9.0"
      "sha256-uTpGTkaBgZRkLDyb793rsykH75jY1r0941M8Od8VqJA=";

  types-aiobotocore-lex-models =
    buildTypesAiobotocorePackage "lex-models" "3.9.0"
      "sha256-uZ1Zd/1+gbeoo53u1nfx09Li45D0uzRjYAVv2kxAqSs=";

  types-aiobotocore-lex-runtime =
    buildTypesAiobotocorePackage "lex-runtime" "3.9.0"
      "sha256-KyS8qk9nbikFEDFZXBdxt4JGAbk41QZTpGz6EQYKWgQ=";

  types-aiobotocore-lexv2-models =
    buildTypesAiobotocorePackage "lexv2-models" "3.9.0"
      "sha256-vMNX9viB9hu9AKDHb5KbzUq3vaZDBAgUA5cq5teAoYw=";

  types-aiobotocore-lexv2-runtime =
    buildTypesAiobotocorePackage "lexv2-runtime" "3.9.0"
      "sha256-c2fNB4BrY0wP5Syt8FWZduHnYCtLqWwe5oM7b4OLA20=";

  types-aiobotocore-license-manager =
    buildTypesAiobotocorePackage "license-manager" "3.9.0"
      "sha256-fesnmjTnAT+/rIJTMp5vrA2vaN5DHxMgjfIBE9ZT1ac=";

  types-aiobotocore-license-manager-linux-subscriptions =
    buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "3.9.0"
      "sha256-LQIc0aiCAXrjpTd9VwH0pCYe11hMVQnIr4wJrMeE/vQ=";

  types-aiobotocore-license-manager-user-subscriptions =
    buildTypesAiobotocorePackage "license-manager-user-subscriptions" "3.9.0"
      "sha256-SSqlwdcGXdWcgoHrfRR+X+/4oidYr671P9aASghXQsI=";

  types-aiobotocore-lightsail =
    buildTypesAiobotocorePackage "lightsail" "3.9.0"
      "sha256-Eki3OGc28wiYluTjH6CDOOzH397lC9Bg3Co+4njrE2E=";

  types-aiobotocore-location =
    buildTypesAiobotocorePackage "location" "3.9.0"
      "sha256-VL2qylZvLBsnyB7ymD0dEJt1/x+9OO2a1Bc7iBHC4NY=";

  types-aiobotocore-logs =
    buildTypesAiobotocorePackage "logs" "3.9.0"
      "sha256-3YS2MGwFWUYW48H277N1lYxAxjBSe+2/qVSyXXtC0bE=";

  types-aiobotocore-lookoutequipment =
    buildTypesAiobotocorePackage "lookoutequipment" "3.9.0"
      "sha256-62PwLcY2MjJ7uSgU7b9A2i/cMOhTAICHJ276fUH8La8=";

  types-aiobotocore-lookoutmetrics =
    buildTypesAiobotocorePackage "lookoutmetrics" "2.24.2"
      "sha256-u84KeWwmp42KajZ3HnztG1106RN4dGh3jcMfSkJYXNY=";

  types-aiobotocore-lookoutvision =
    buildTypesAiobotocorePackage "lookoutvision" "2.24.2"
      "sha256-HvNqynXLpYFJceCmrlncodqWuoczilMB8QtbCS5pcDM=";

  types-aiobotocore-m2 =
    buildTypesAiobotocorePackage "m2" "3.9.0"
      "sha256-3PhKAGXhTMMI3NH+7nk+tGYMDu9h4AQnyL1stMTMn50=";

  types-aiobotocore-machinelearning =
    buildTypesAiobotocorePackage "machinelearning" "3.9.0"
      "sha256-zISasp6FRv3uBr6/wpi77IupBJXtAzmsMAt+woPvv78=";

  types-aiobotocore-macie =
    buildTypesAiobotocorePackage "macie" "2.7.0"
      "sha256-hJJtGsK2b56nKX1ZhiarC+ffyjHYWRiC8II4oyDZWWw=";

  types-aiobotocore-macie2 =
    buildTypesAiobotocorePackage "macie2" "3.9.0"
      "sha256-FoiA8hE34EK8kRpH65KumSop4wU6hg/ZdC6UWOeNzZk=";

  types-aiobotocore-managedblockchain =
    buildTypesAiobotocorePackage "managedblockchain" "3.9.0"
      "sha256-6uGPtBpoqyFkbdZvk8B+qU3OjNVrxOvW7RCIy7UOUUs=";

  types-aiobotocore-managedblockchain-query =
    buildTypesAiobotocorePackage "managedblockchain-query" "3.9.0"
      "sha256-sLfZzNcI2dw8Ia6n2rL83MSocleMVH5G9kKqtGcuZj0=";

  types-aiobotocore-marketplace-catalog =
    buildTypesAiobotocorePackage "marketplace-catalog" "3.9.0"
      "sha256-Hy/2LnwMVTzi5XuakC+3/am/Lxdp7EtULAOPxDWEx2E=";

  types-aiobotocore-marketplace-entitlement =
    buildTypesAiobotocorePackage "marketplace-entitlement" "3.9.0"
      "sha256-sX9qtYeh+1yDqPcrTL9HRSgufQBiSSs86aPHnPPV8WU=";

  types-aiobotocore-marketplacecommerceanalytics =
    buildTypesAiobotocorePackage "marketplacecommerceanalytics" "3.9.0"
      "sha256-DAQu0hk53Nayib/0Ud315wulKMjSrC1MLh/CjY+C6Lc=";

  types-aiobotocore-mediaconnect =
    buildTypesAiobotocorePackage "mediaconnect" "3.9.0"
      "sha256-DejWlR/PYdqMt3+03JLxqkP0cIeYk18rtJrvPxoRRoM=";

  types-aiobotocore-mediaconvert =
    buildTypesAiobotocorePackage "mediaconvert" "3.9.0"
      "sha256-rzmBT1YAqvu+HSBgHsfPxzRrEdG9YHLoK0EOGd+Y5ac=";

  types-aiobotocore-medialive =
    buildTypesAiobotocorePackage "medialive" "3.9.0"
      "sha256-B2FVQewSi9V2QaQvPQMbaos4VEdnJi+xjAvCL3yPRmw=";

  types-aiobotocore-mediapackage =
    buildTypesAiobotocorePackage "mediapackage" "3.9.0"
      "sha256-1xOPDm1N0QRMBU3iEsYxkS/mOLFd9sI3gk8TVuJUPCs=";

  types-aiobotocore-mediapackage-vod =
    buildTypesAiobotocorePackage "mediapackage-vod" "3.9.0"
      "sha256-qGvjLKKVR0tB32iC2GxMphSNkJ2zwEL99fiGuFSwWcw=";

  types-aiobotocore-mediapackagev2 =
    buildTypesAiobotocorePackage "mediapackagev2" "3.9.0"
      "sha256-NTA8wwTN8NUTTuZ2ea/13wNiNyWc9+oOavHQcLTbv2E=";

  types-aiobotocore-mediastore =
    buildTypesAiobotocorePackage "mediastore" "3.9.0"
      "sha256-GWOOOWbYD8+3Q+c/saZP3T1TmdLplDQjG/Aa4lZIdro=";

  types-aiobotocore-mediastore-data =
    buildTypesAiobotocorePackage "mediastore-data" "3.9.0"
      "sha256-iv99h98IhP4MIGsOjW9FEfGZflO3wBA89rd5BxzH6Yg=";

  types-aiobotocore-mediatailor =
    buildTypesAiobotocorePackage "mediatailor" "3.9.0"
      "sha256-76l36PhudC3uXkRq6EpQGYzJ1pJ9kmFN33MX+jFgPBA=";

  types-aiobotocore-medical-imaging =
    buildTypesAiobotocorePackage "medical-imaging" "3.9.0"
      "sha256-FHa218mbzk8hePrt56aXHu9o/hsMo5BCY9zHozdp/iE=";

  types-aiobotocore-memorydb =
    buildTypesAiobotocorePackage "memorydb" "3.9.0"
      "sha256-cCSLEW7crUeqVi2/+X5wa5g45fS/yiXI+2ilPiWXZgM=";

  types-aiobotocore-meteringmarketplace =
    buildTypesAiobotocorePackage "meteringmarketplace" "3.9.0"
      "sha256-ALZIywh8fN64uiNStCa/TGStC0JY8Gkd21yCZ0G4Ug8=";

  types-aiobotocore-mgh =
    buildTypesAiobotocorePackage "mgh" "3.9.0"
      "sha256-uhx00ZBB/xkFD4u0uzJ5jHTOUbcFZCMrXNccsMeU9Rk=";

  types-aiobotocore-mgn =
    buildTypesAiobotocorePackage "mgn" "3.9.0"
      "sha256-wOAMtrWWHwhNbc4GSikSeKPV+O9JxBKkloHmKg9RIc4=";

  types-aiobotocore-migration-hub-refactor-spaces =
    buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "3.9.0"
      "sha256-vzwFcFCRmJlW8KP1b/LC0hl/72kEtGp8mXI1dHhdJGQ=";

  types-aiobotocore-migrationhub-config =
    buildTypesAiobotocorePackage "migrationhub-config" "3.9.0"
      "sha256-2sv2aI+ww+bLJ4tx1SAxPlka00UgbduHj6P3C8C+AG4=";

  types-aiobotocore-migrationhuborchestrator =
    buildTypesAiobotocorePackage "migrationhuborchestrator" "3.9.0"
      "sha256-83fWZvUsyx9DpHzraR8YGHpvmJ1gcF8aXqhEHrZcpeI=";

  types-aiobotocore-migrationhubstrategy =
    buildTypesAiobotocorePackage "migrationhubstrategy" "3.9.0"
      "sha256-bQ0IzC4xFnTv9d5Z/qjithhHjTPdU7lvbKxelK/Gsb8=";

  types-aiobotocore-mobile =
    buildTypesAiobotocorePackage "mobile" "2.13.2"
      "sha256-OxB91BCAmYnY72JBWZaBlEkpAxN2Q5aY4i1Pt3eD9hc=";

  types-aiobotocore-mq =
    buildTypesAiobotocorePackage "mq" "3.9.0"
      "sha256-zxc1geFwd/m1xU8FEC8iz7I/Itbno/eZbpuixwX8c7A=";

  types-aiobotocore-mturk =
    buildTypesAiobotocorePackage "mturk" "3.9.0"
      "sha256-E7QU6wSTDwxF3Vwi7bhsvGXh45brUPYu2jXAf90TJS4=";

  types-aiobotocore-mwaa =
    buildTypesAiobotocorePackage "mwaa" "3.9.0"
      "sha256-rw5F0Dzaxm5VKrgMqLsB/SOGlGHuhmNdERWor4DM3PM=";

  types-aiobotocore-neptune =
    buildTypesAiobotocorePackage "neptune" "3.9.0"
      "sha256-DDRT7uCCw/viTYdC55NHKLdGhXzR/bONRkZfKoO9LVk=";

  types-aiobotocore-network-firewall =
    buildTypesAiobotocorePackage "network-firewall" "3.9.0"
      "sha256-BbtowObW0Zx9mEqnQgEYEChMKoLUzPREirRHoLjdFAc=";

  types-aiobotocore-networkmanager =
    buildTypesAiobotocorePackage "networkmanager" "3.9.0"
      "sha256-LsEf2Hc5y1PG6gZsU0Pmwpf2ST8L08xuwyZzC8OaTg4=";

  types-aiobotocore-networkmonitor =
    buildTypesAiobotocorePackage "networkmonitor" "3.9.0"
      "sha256-vjd3hn3jW3rNgNSl2pMbWWHwrC2TdxTuTqcehpes58Y=";

  types-aiobotocore-nimble =
    buildTypesAiobotocorePackage "nimble" "2.15.2"
      "sha256-PChX5Jbgr0d1YaTZU9AbX3cM7NrhkyunK6/X3l+I8Q0=";

  types-aiobotocore-oam =
    buildTypesAiobotocorePackage "oam" "3.9.0"
      "sha256-qVJYiZ2oHPmVldEVYrq8Uld173vU9xOVpM7GWqTlf+A=";

  types-aiobotocore-omics =
    buildTypesAiobotocorePackage "omics" "3.9.0"
      "sha256-1LHvlIOdq9UTzBoXraAxHAt1imaaqk49LplEXgbvoYE=";

  types-aiobotocore-opensearch =
    buildTypesAiobotocorePackage "opensearch" "3.9.0"
      "sha256-5/MEsZ/Rq1L+Ir17TcOTsBurMUaYPEygRH/jcjldnZ0=";

  types-aiobotocore-opensearchserverless =
    buildTypesAiobotocorePackage "opensearchserverless" "3.9.0"
      "sha256-DCwCNHm+UFQmAzBvV+YF0CPrEFKbTGy9Vs6yu95br04=";

  types-aiobotocore-opsworks =
    buildTypesAiobotocorePackage "opsworks" "2.24.2"
      "sha256-ScEMFhogJRX6ykymK3rqYniGVcyJEsECKvnnbT3xv1A=";

  types-aiobotocore-opsworkscm =
    buildTypesAiobotocorePackage "opsworkscm" "2.24.2"
      "sha256-i+qoE5XXWpZ7dQeDagkD2MhnBjwbKTJYyZxATDh8h9M=";

  types-aiobotocore-organizations =
    buildTypesAiobotocorePackage "organizations" "3.9.0"
      "sha256-P+V9mdnIJxB1xS+5eJGVdCG6dwfvn1o3UyUDUaH/Cq4=";

  types-aiobotocore-osis =
    buildTypesAiobotocorePackage "osis" "3.9.0"
      "sha256-+43gnBfzMLsfj3pEGX5GAOFKcIU5UP6TN2Z870jU/pc=";

  types-aiobotocore-outposts =
    buildTypesAiobotocorePackage "outposts" "3.9.0"
      "sha256-20w97iuRx9LV+6BXNPtbkLBxCo5JuWi3+Zt3HKC/R8g=";

  types-aiobotocore-panorama =
    buildTypesAiobotocorePackage "panorama" "3.7.0"
      "sha256-yn1EAIvzNfFR1a3r8y9Ri5nOdprgEAYBuXw2Wt1hYIs=";

  types-aiobotocore-payment-cryptography =
    buildTypesAiobotocorePackage "payment-cryptography" "3.9.0"
      "sha256-rICvttnXLUoh82jwJxnGvQZeGu6Cz5SgV8dgbKamdfY=";

  types-aiobotocore-payment-cryptography-data =
    buildTypesAiobotocorePackage "payment-cryptography-data" "3.9.0"
      "sha256-Y+tukohu/PPrdUzs+3MCa6Kdqnpd/R51xt56jZlZus4=";

  types-aiobotocore-personalize =
    buildTypesAiobotocorePackage "personalize" "3.9.0"
      "sha256-MeLV79CwcEXQ4mfbXMdqBqfSnTMSfjfzCzwi1DNvcaI=";

  types-aiobotocore-personalize-events =
    buildTypesAiobotocorePackage "personalize-events" "3.9.0"
      "sha256-vcXQ0sXvAlhMIV21OZYZ5fzVkqC6i0wybBMKYNZ7bR0=";

  types-aiobotocore-personalize-runtime =
    buildTypesAiobotocorePackage "personalize-runtime" "3.9.0"
      "sha256-E0Jwk7rTjGrqZT/4JTemQGqNJj50uIM+SPUXZPv103Q=";

  types-aiobotocore-pi =
    buildTypesAiobotocorePackage "pi" "3.9.0"
      "sha256-VJ+5FE7L/pOGujJ0U9BbgOYCAlaMJ1atQfLndtnJP6k=";

  types-aiobotocore-pinpoint =
    buildTypesAiobotocorePackage "pinpoint" "3.9.0"
      "sha256-Os2wWFLyQJ7SHG2dazy/jxlqiwb6j2m+1368KCg5J4A=";

  types-aiobotocore-pinpoint-email =
    buildTypesAiobotocorePackage "pinpoint-email" "3.9.0"
      "sha256-8WHmxt2MYbqN8/bwq/4Co5oggt7Owi9Atfi4RjOySUc=";

  types-aiobotocore-pinpoint-sms-voice =
    buildTypesAiobotocorePackage "pinpoint-sms-voice" "3.9.0"
      "sha256-/3JOjhyQ5tWFRYFEQnCcdMFSquuoHI9s9XIkG3f2Hhc=";

  types-aiobotocore-pinpoint-sms-voice-v2 =
    buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "3.9.0"
      "sha256-5HQHJ5EFAUy/r+8xEGsxLItdYnPyiqXSCa5Pr6AgVdo=";

  types-aiobotocore-pipes =
    buildTypesAiobotocorePackage "pipes" "3.9.0"
      "sha256-YL4fx9Ybxi6eEPqFqdpgFjUcMv+0DaS78kqKDLCTsmQ=";

  types-aiobotocore-polly =
    buildTypesAiobotocorePackage "polly" "3.9.0"
      "sha256-+bUdicBdGO6DmOHom1GJFZSeMnvXXxiVXfoXAGOQh5s=";

  types-aiobotocore-pricing =
    buildTypesAiobotocorePackage "pricing" "3.9.0"
      "sha256-DOwvSKHtBiMKM0fl7nlKnaNmTk6nAqXppZa63eCpivA=";

  types-aiobotocore-privatenetworks =
    buildTypesAiobotocorePackage "privatenetworks" "2.22.0"
      "sha256-yaYvgVKcr3l2eq0dMzmQEZHxgblTLlVF9cZRnObiB7M=";

  types-aiobotocore-proton =
    buildTypesAiobotocorePackage "proton" "3.9.0"
      "sha256-A9+sL45zH1Vq4c38g0XoRnQVlxBscBmCKWVgf/uM9q0=";

  types-aiobotocore-qapps =
    buildTypesAiobotocorePackage "qapps" "3.9.0"
      "sha256-y4424drt8fvRvd2LVrkwTmtBSjuJzVhsdt6uy1B4qks=";

  types-aiobotocore-qbusiness =
    buildTypesAiobotocorePackage "qbusiness" "3.9.0"
      "sha256-jTbxgGJRJDc/68fm172raG+B4IvxyaG03g07aC9Kgvw=";

  types-aiobotocore-qconnect =
    buildTypesAiobotocorePackage "qconnect" "3.9.0"
      "sha256-gnhVhP3cHrWAeA/rbLNySLBn9XjIAypruGdrFDSrkok=";

  types-aiobotocore-qldb =
    buildTypesAiobotocorePackage "qldb" "2.24.2"
      "sha256-qrSbXgc4DBb2kNg0ydb1vT9EmRqQWNIfuNOVsK8BPY0=";

  types-aiobotocore-qldb-session =
    buildTypesAiobotocorePackage "qldb-session" "2.24.2"
      "sha256-Lk9RLigcg4F/AsgKneBUoyPyeUh46ra+BLCw94b74eU=";

  types-aiobotocore-quicksight =
    buildTypesAiobotocorePackage "quicksight" "3.9.0"
      "sha256-XwnZ/042BgVosbcswkj3Xn8sLoS62wZntXX4rbVN9mI=";

  types-aiobotocore-ram =
    buildTypesAiobotocorePackage "ram" "3.9.0"
      "sha256-5j1zJ0K2Q2I2Eh9bNMkWjAhPPkyHeKaxtix0kN4eh94=";

  types-aiobotocore-rbin =
    buildTypesAiobotocorePackage "rbin" "3.9.0"
      "sha256-IFGcw9HJ8M0O9+W6J50uSEHe34uhKJ4+WQ6WRoKa4PI=";

  types-aiobotocore-rds =
    buildTypesAiobotocorePackage "rds" "3.9.0"
      "sha256-ctpBMzBStCW8FsXMnWpL3rZTw/p87jXRbIf7LgNGv+Y=";

  types-aiobotocore-rds-data =
    buildTypesAiobotocorePackage "rds-data" "3.9.0"
      "sha256-uZG8ewqwAHVlJ2lcWe0dIqAmAoQmxLRcAGT/wTXOJ20=";

  types-aiobotocore-redshift =
    buildTypesAiobotocorePackage "redshift" "3.9.0"
      "sha256-v0K5TX3JDg0Y+/VacXEkWrT7GNg/xRuv8I+6L+3g9Zc=";

  types-aiobotocore-redshift-data =
    buildTypesAiobotocorePackage "redshift-data" "3.9.0"
      "sha256-ko7Ig0SNAToGWjq9PLxjqTa9aUlUamfs8O43kZBtk/w=";

  types-aiobotocore-redshift-serverless =
    buildTypesAiobotocorePackage "redshift-serverless" "3.9.0"
      "sha256-LotPy6GjBJAvTChNt0Gg1ylL3Kmc0pTOeU/tMxVyXq8=";

  types-aiobotocore-rekognition =
    buildTypesAiobotocorePackage "rekognition" "3.9.0"
      "sha256-SDquakZGhR72xBpjGZiXKfvrOHT8m86rthjO2j30HRA=";

  types-aiobotocore-resiliencehub =
    buildTypesAiobotocorePackage "resiliencehub" "3.9.0"
      "sha256-opuxNkgTKFy4shgzeKh0bkPQNbcVAc1lSxnu0mi416s=";

  types-aiobotocore-resource-explorer-2 =
    buildTypesAiobotocorePackage "resource-explorer-2" "3.9.0"
      "sha256-ljx2MuLqPFVOUyS3+Sd4HP9OD+ic/gU9T0Xzm5nen3w=";

  types-aiobotocore-resource-groups =
    buildTypesAiobotocorePackage "resource-groups" "3.9.0"
      "sha256-jwAemcnu78WwwAgKD0HdAt3Pm2adp3Zrk1vrxVFdpE4=";

  types-aiobotocore-resourcegroupstaggingapi =
    buildTypesAiobotocorePackage "resourcegroupstaggingapi" "3.9.0"
      "sha256-sXLHeRD8tvXGB+2peXB9q77NYJxn0NNJXyrHGi0b4Ek=";

  types-aiobotocore-robomaker =
    buildTypesAiobotocorePackage "robomaker" "2.24.2"
      "sha256-EczunxMisSO9t2iYzXuzTeFiNalu2EyDRIOE7TW5fOg=";

  types-aiobotocore-rolesanywhere =
    buildTypesAiobotocorePackage "rolesanywhere" "3.9.0"
      "sha256-h2uEAItFXoSKwysqASghyxLA1jMvFkNjMOPrC6Cg5Kw=";

  types-aiobotocore-route53 =
    buildTypesAiobotocorePackage "route53" "3.9.0"
      "sha256-YybqERM8KUxG+NgH13Lst0b89+xBjo+EinAh4cWBMN0=";

  types-aiobotocore-route53-recovery-cluster =
    buildTypesAiobotocorePackage "route53-recovery-cluster" "3.9.0"
      "sha256-XYXPFuhtqmpbn5HitxCLavyKxtXGm3wS/5JyaqEjKfM=";

  types-aiobotocore-route53-recovery-control-config =
    buildTypesAiobotocorePackage "route53-recovery-control-config" "3.9.0"
      "sha256-ebS/6ubQKTAyHXWqNo8e4sd+uJut3pk0XFNILpZziSg=";

  types-aiobotocore-route53-recovery-readiness =
    buildTypesAiobotocorePackage "route53-recovery-readiness" "3.9.0"
      "sha256-2np73Zk8AQ2FpHrg7SUfzAdGmCrY7wdlfM0/tLr1xnk=";

  types-aiobotocore-route53domains =
    buildTypesAiobotocorePackage "route53domains" "3.9.0"
      "sha256-FniUEKEG/V2t3UqjRhsugUBIG0IK2QE7xN1J+LlAi1g=";

  types-aiobotocore-route53resolver =
    buildTypesAiobotocorePackage "route53resolver" "3.9.0"
      "sha256-fzKx/N0a0zgBvdTHD/iO0AnQIyZDvBzLA9EkCtxH5GY=";

  types-aiobotocore-rum =
    buildTypesAiobotocorePackage "rum" "3.9.0"
      "sha256-Fklb5nxbj1mdhNpJ6hwCtlkv6nIcWF6F7hb9RxtWdok=";

  types-aiobotocore-s3 =
    buildTypesAiobotocorePackage "s3" "3.9.0"
      "sha256-v2l4qjDNKuW0nP1OavwtiZbsSGZ99OA9y1bXrm17BOg=";

  types-aiobotocore-s3control =
    buildTypesAiobotocorePackage "s3control" "3.9.0"
      "sha256-npXOlTCUE/h4KBYehLkZZtZZEW7+B+WcCN8FB60yMM0=";

  types-aiobotocore-s3outposts =
    buildTypesAiobotocorePackage "s3outposts" "3.9.0"
      "sha256-0m7+JqBaYqZbszX+Ol9GoapJrQ2aLoK4OY0QbLjsDYY=";

  types-aiobotocore-sagemaker =
    buildTypesAiobotocorePackage "sagemaker" "3.9.0"
      "sha256-hWCLUu/y+FzfEa0wsmOH8PlN62B/gL+m526gVO03XJQ=";

  types-aiobotocore-sagemaker-a2i-runtime =
    buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "3.9.0"
      "sha256-5V3BVeUReyBfCnKilPC4png0j6Z69c/expTQItGbuI4=";

  types-aiobotocore-sagemaker-edge =
    buildTypesAiobotocorePackage "sagemaker-edge" "3.9.0"
      "sha256-nXmbpAn9TOg0rzW43P9f1f29d2VUbtAXXOCx4xiOCR8=";

  types-aiobotocore-sagemaker-featurestore-runtime =
    buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "3.9.0"
      "sha256-Ipl/B0+Qy5xYveRMVucaWb5KXRfz76vkH8pH/naH48Y=";

  types-aiobotocore-sagemaker-geospatial =
    buildTypesAiobotocorePackage "sagemaker-geospatial" "3.9.0"
      "sha256-7Ne1yA+vnnwuY8/zP1y7OVNraaQEkPJArsZpSSZh6o0=";

  types-aiobotocore-sagemaker-metrics =
    buildTypesAiobotocorePackage "sagemaker-metrics" "3.9.0"
      "sha256-NfHkgCFvxAo+1Bz+xCoLDxejs144JyV13+Lh4x0tiGI=";

  types-aiobotocore-sagemaker-runtime =
    buildTypesAiobotocorePackage "sagemaker-runtime" "3.9.0"
      "sha256-iP9h6/xLRQvmAo7kF+fjB+uNacGtU9I9Ev0xv/vOs3M=";

  types-aiobotocore-savingsplans =
    buildTypesAiobotocorePackage "savingsplans" "3.9.0"
      "sha256-xWpSooygjyeoZ40GoWchPaX+XHWb6Hi+8bOJtbqTueY=";

  types-aiobotocore-scheduler =
    buildTypesAiobotocorePackage "scheduler" "3.9.0"
      "sha256-Wu+NBbSC9OufWCKvE0guLv37iY9QGKKFTFq7j0X9ho4=";

  types-aiobotocore-schemas =
    buildTypesAiobotocorePackage "schemas" "3.9.0"
      "sha256-sQ7ti2Mg5soQtKjCyebE6fZEcAc4aoZhD83XfYF2Ajg=";

  types-aiobotocore-sdb =
    buildTypesAiobotocorePackage "sdb" "3.9.0"
      "sha256-Dw1ZE0VwF2almwZuz1nKi2JDB1GR+6ficrfmAbl29Dw=";

  types-aiobotocore-secretsmanager =
    buildTypesAiobotocorePackage "secretsmanager" "3.9.0"
      "sha256-+PIx6haiFmb0q0g5W23BiZWOdY3vPShKF1w+hyg79mY=";

  types-aiobotocore-securityhub =
    buildTypesAiobotocorePackage "securityhub" "3.9.0"
      "sha256-B57642giZ+ZT5FffjeFLQZM1QY6pChB1G0ZFYqODYiI=";

  types-aiobotocore-securitylake =
    buildTypesAiobotocorePackage "securitylake" "3.9.0"
      "sha256-URcB2b1mNFT7CsM5yn0Kz1t9L6ECbgJwR+/bmlNucOo=";

  types-aiobotocore-serverlessrepo =
    buildTypesAiobotocorePackage "serverlessrepo" "3.9.0"
      "sha256-GxKcZvKJBOn83EHRltkKE31Z42KXu9/bfmOTU5sUKRs=";

  types-aiobotocore-service-quotas =
    buildTypesAiobotocorePackage "service-quotas" "3.9.0"
      "sha256-l5zOsP0G72Qu95s8Vkr8CL/CSGbqfPIgCRc51nkLP1g=";

  types-aiobotocore-servicecatalog =
    buildTypesAiobotocorePackage "servicecatalog" "3.9.0"
      "sha256-eM8MhhLmLm/C0ypf8JrhjJj7J2TFPxMXleAEGwX4Ylc=";

  types-aiobotocore-servicecatalog-appregistry =
    buildTypesAiobotocorePackage "servicecatalog-appregistry" "3.9.0"
      "sha256-Rc1gpXwPWviGq8qSqvZxXeRDy6jRzyKorW8+1/37TRc=";

  types-aiobotocore-servicediscovery =
    buildTypesAiobotocorePackage "servicediscovery" "3.9.0"
      "sha256-2aTYrvFshKmbjbeCH5Rz0ljdb40MN0iq08Gma8NjboA=";

  types-aiobotocore-ses =
    buildTypesAiobotocorePackage "ses" "3.9.0"
      "sha256-OxoTdpZ55JCvUFFoMOZ61ojbby7rpyl+prJtZVqVd/M=";

  types-aiobotocore-sesv2 =
    buildTypesAiobotocorePackage "sesv2" "3.9.0"
      "sha256-9doewDhUqhbMo18jkE6oFidCfNfTqTgg6/aRoOP561I=";

  types-aiobotocore-shield =
    buildTypesAiobotocorePackage "shield" "3.9.0"
      "sha256-3B3I/phGCphUjG8KRB60D1C/Cb1juzXDIeWyk7fSOk8=";

  types-aiobotocore-signer =
    buildTypesAiobotocorePackage "signer" "3.9.0"
      "sha256-NRc+AndZYGPs6HuSlJytBfVX0HccurMP2sz9LL7QUpc=";

  types-aiobotocore-simspaceweaver =
    buildTypesAiobotocorePackage "simspaceweaver" "3.7.0"
      "sha256-tZQL781zQI+vVvO0S3cHzw5RGAHKXeNeJW7E8tzCHA4=";

  types-aiobotocore-sms =
    buildTypesAiobotocorePackage "sms" "2.24.2"
      "sha256-aZuGmKtxe3ERjMUZ5jNiZUaVUqDaCHKQQ6wMTsGkcVs=";

  types-aiobotocore-sms-voice =
    buildTypesAiobotocorePackage "sms-voice" "2.22.0"
      "sha256-nlg8QppdMa4MMLUQZXcxnypzv5II9PqEtuVc09UmjKU=";

  types-aiobotocore-snow-device-management =
    buildTypesAiobotocorePackage "snow-device-management" "3.9.0"
      "sha256-slWED2tLxkdyfPSrFZSqkBtiXH43vq0BBWC8rYGiJZI=";

  types-aiobotocore-snowball =
    buildTypesAiobotocorePackage "snowball" "3.9.0"
      "sha256-Z225AI63FnuuLXUS9fqsMuL0uezPVrNBIo4ztzNg4Eg=";

  types-aiobotocore-sns =
    buildTypesAiobotocorePackage "sns" "3.9.0"
      "sha256-If/wXsR4olya2mlkckF0avpGccO2/+qjM3EhWUk4eBQ=";

  types-aiobotocore-sqs =
    buildTypesAiobotocorePackage "sqs" "3.9.0"
      "sha256-rpE8UJfnn4LFQOZEDjvO55Ekfd0TLB5vjFKgLr5/XrU=";

  types-aiobotocore-ssm =
    buildTypesAiobotocorePackage "ssm" "3.9.0"
      "sha256-LDeX5XuDpyzOPRU27Xmdc4GdxOmX8ZAwTMAZz8r/v+w=";

  types-aiobotocore-ssm-contacts =
    buildTypesAiobotocorePackage "ssm-contacts" "3.9.0"
      "sha256-0FN1wZr7mpvN1hidZah2xvfLWzYqvKMd+euhvs9mzF8=";

  types-aiobotocore-ssm-incidents =
    buildTypesAiobotocorePackage "ssm-incidents" "3.9.0"
      "sha256-uEm0s0aF4lShRy9JNpq1yK4BpB1H0/bkIMqBsuYZoek=";

  types-aiobotocore-ssm-sap =
    buildTypesAiobotocorePackage "ssm-sap" "3.9.0"
      "sha256-K6W1ZwZZKqVImzX8S/htf3Bs/xFtXfTy7g+rC64+GUk=";

  types-aiobotocore-sso =
    buildTypesAiobotocorePackage "sso" "3.9.0"
      "sha256-/+m2OqMwz4/Aa3hh7j5k0lT5pjBgPPq0e+L5tfamHPE=";

  types-aiobotocore-sso-admin =
    buildTypesAiobotocorePackage "sso-admin" "3.9.0"
      "sha256-OP0pFtGnR4Q6ajoFhKkseaeTnLjEd306XZAImpHkedc=";

  types-aiobotocore-sso-oidc =
    buildTypesAiobotocorePackage "sso-oidc" "3.9.0"
      "sha256-/C4k3fUyWr0rtc6one7iw7USlotaPx/8zZtWRQxv0bU=";

  types-aiobotocore-stepfunctions =
    buildTypesAiobotocorePackage "stepfunctions" "3.9.0"
      "sha256-0Hr6q+J66PtwhG7esbQArW8Rw7CDsc0TpfXK74Azg7Q=";

  types-aiobotocore-storagegateway =
    buildTypesAiobotocorePackage "storagegateway" "3.9.0"
      "sha256-Y5mE4wxh3or8SHHqcKaCihGssehdkOF0ARfE+loeIrI=";

  types-aiobotocore-sts =
    buildTypesAiobotocorePackage "sts" "3.9.0"
      "sha256-+DsQBTPVi71A6XGumO2uKOEtZJITIPPy+6IUYoSPZfc=";

  types-aiobotocore-support =
    buildTypesAiobotocorePackage "support" "3.9.0"
      "sha256-PYfWYHlrS1xQ8cBi7npsZxe0+DSCbpznz6FwcivL2aE=";

  types-aiobotocore-support-app =
    buildTypesAiobotocorePackage "support-app" "3.9.0"
      "sha256-AivbPKXk0spK66z3BLIwWrxTieikIn+7a0ROwwpz1hk=";

  types-aiobotocore-swf =
    buildTypesAiobotocorePackage "swf" "3.9.0"
      "sha256-r+eiyNzOx/ByGza9+oCCb/IEA7e4JMZPwFt4ViGFMCk=";

  types-aiobotocore-synthetics =
    buildTypesAiobotocorePackage "synthetics" "3.9.0"
      "sha256-FW6LFoKJBGxBbpXsxPg5SXUlWheGvMZXofnwwOjU6W4=";

  types-aiobotocore-textract =
    buildTypesAiobotocorePackage "textract" "3.9.0"
      "sha256-oYZBVecvbl1/GOX4BKPHtgnDZvCh14OvbcKz3tvDJLc=";

  types-aiobotocore-timestream-query =
    buildTypesAiobotocorePackage "timestream-query" "3.9.0"
      "sha256-z4+b/4fLXGNL4l2IByKSLYhLABS4z4vfXMIDC6KNybM=";

  types-aiobotocore-timestream-write =
    buildTypesAiobotocorePackage "timestream-write" "3.9.0"
      "sha256-pjYLCA4Lhddx1z/awZMu68lftoXg8abkc7SBHK3prwo=";

  types-aiobotocore-tnb =
    buildTypesAiobotocorePackage "tnb" "3.9.0"
      "sha256-9qtnLu1vohh+1J/s94FIBJjvTzYNw0x0+Dk9Nr49PLs=";

  types-aiobotocore-transcribe =
    buildTypesAiobotocorePackage "transcribe" "3.9.0"
      "sha256-mc3D1QfIMGk+6oDgB07bCmEhKlnxGQM+w96O2HWhk3A=";

  types-aiobotocore-transfer =
    buildTypesAiobotocorePackage "transfer" "3.9.0"
      "sha256-lSiyFJvFnBtIQIc4P4hwSMorwenjvtfRtv1kAwcxbPc=";

  types-aiobotocore-translate =
    buildTypesAiobotocorePackage "translate" "3.9.0"
      "sha256-kmA48TUzjICyNF0R8oF8fFc4haeiIQ/veC11UwFMPGU=";

  types-aiobotocore-verifiedpermissions =
    buildTypesAiobotocorePackage "verifiedpermissions" "3.9.0"
      "sha256-lu3Lju8c7EZEbpqRjmjfcBr7tvNR6mYLTObl6X1FzVg=";

  types-aiobotocore-voice-id =
    buildTypesAiobotocorePackage "voice-id" "3.9.0"
      "sha256-/llxt93LmSNoS9wFkVrXWyU+Agz8QQKTkaytBKXh8gM=";

  types-aiobotocore-vpc-lattice =
    buildTypesAiobotocorePackage "vpc-lattice" "3.9.0"
      "sha256-ETU01KBhnNRGxXtwpo3Kr9Z4myI1r1nBxOKY14bhAMU=";

  types-aiobotocore-waf =
    buildTypesAiobotocorePackage "waf" "3.9.0"
      "sha256-LrKHK6UMzgwOgyvHp3iyZ9AyHx4roMQFHA66grCSVMg=";

  types-aiobotocore-waf-regional =
    buildTypesAiobotocorePackage "waf-regional" "3.9.0"
      "sha256-kIXenyn3J8V/n72xNNWBGWvY+UFkFnn+Cu+DBcUrKTU=";

  types-aiobotocore-wafv2 =
    buildTypesAiobotocorePackage "wafv2" "3.9.0"
      "sha256-PVFxsO8sW3H0MazRDpdlK2jPVWFOLo4aEPRpeFTqVGg=";

  types-aiobotocore-wellarchitected =
    buildTypesAiobotocorePackage "wellarchitected" "3.9.0"
      "sha256-XmyfafRc7VfI0NUhNZohPjR5vxXp0wBmIIM69Hd2IgU=";

  types-aiobotocore-wisdom =
    buildTypesAiobotocorePackage "wisdom" "3.9.0"
      "sha256-kUi3/E8H1qnneVoLdkZpDfdSKl4SFIbe22prC5Ci6qc=";

  types-aiobotocore-workdocs =
    buildTypesAiobotocorePackage "workdocs" "3.9.0"
      "sha256-3aAReEtcMYCkiFLqFvInJ7qEiEJafeWlgHnr3esZY4Q=";

  types-aiobotocore-worklink =
    buildTypesAiobotocorePackage "worklink" "2.15.1"
      "sha256-VvuxiybvGaehPqyVUYGO1bbVSQ0OYgk6LbzgoKLHF2c=";

  types-aiobotocore-workmail =
    buildTypesAiobotocorePackage "workmail" "3.9.0"
      "sha256-l6L6qYt6JlcPmyX9mYvWtxkK9cvXzXADzADN1pHNNZI=";

  types-aiobotocore-workmailmessageflow =
    buildTypesAiobotocorePackage "workmailmessageflow" "3.9.0"
      "sha256-Q0x54t2k7bUUdycuFMGOZaDa1flG0Kro5qMtS/Iizw4=";

  types-aiobotocore-workspaces =
    buildTypesAiobotocorePackage "workspaces" "3.9.0"
      "sha256-v9W86Yk7FBb6DmkbvZ7PFVmvqUmU9cVH3hWbfHALh2o=";

  types-aiobotocore-workspaces-web =
    buildTypesAiobotocorePackage "workspaces-web" "3.9.0"
      "sha256-NUqPEMwI7sNWj8e8pvAwWXkkPDEPIfUF5AfiGI1GUj8=";

  types-aiobotocore-xray =
    buildTypesAiobotocorePackage "xray" "3.9.0"
      "sha256-GVqfY6AHFBnzHtv89eSSYJrvLr2iUguJJijm7WVQkRQ=";
}
