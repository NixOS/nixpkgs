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
    buildTypesAiobotocorePackage "accessanalyzer" "2.20.0"
      "sha256-GzYBXx/nALIB7juj8ntFWeVV0yiL9kA6H0wq61T79CM=";

  types-aiobotocore-account =
    buildTypesAiobotocorePackage "account" "2.20.0"
      "sha256-ScEdICacszsNBc9BA8OpxB1z1Kd9aCXt4jbKxW0WogQ=";

  types-aiobotocore-acm =
    buildTypesAiobotocorePackage "acm" "2.20.0"
      "sha256-IZ4aBhqXdqoOQ40Pin2YLnTbmPfN/hAuMcTSJ8gzklg=";

  types-aiobotocore-acm-pca =
    buildTypesAiobotocorePackage "acm-pca" "2.20.0"
      "sha256-YjdxMRie8qPVuZ/dtdU/vR7s911zzE4LGT4IamvpnTY=";

  types-aiobotocore-alexaforbusiness =
    buildTypesAiobotocorePackage "alexaforbusiness" "2.13.0"
      "sha256-+w/InoQR2aZ5prieGhgEEp7auBiSSghG5zIIHY5Kyao=";

  types-aiobotocore-amp =
    buildTypesAiobotocorePackage "amp" "2.20.0"
      "sha256-olMva1EMKNqNYP9mfOW/7RmzjyFo3h39rqfQFmPHjHA=";

  types-aiobotocore-amplify =
    buildTypesAiobotocorePackage "amplify" "2.20.0"
      "sha256-hRbAk4G5Rs6gvhkyK4U7nv3vGzzcpr13wdxLxFZNr2k=";

  types-aiobotocore-amplifybackend =
    buildTypesAiobotocorePackage "amplifybackend" "2.20.0"
      "sha256-Ejy4uUg5YJ82Dq+yj+E7STDcM7U4SFfNcxTSUITwQF0=";

  types-aiobotocore-amplifyuibuilder =
    buildTypesAiobotocorePackage "amplifyuibuilder" "2.20.0"
      "sha256-EiBluPSXUUOE4INvAjISa93Mnf18GVmrfQk3A9aprYk=";

  types-aiobotocore-apigateway =
    buildTypesAiobotocorePackage "apigateway" "2.20.0"
      "sha256-oGmgcRFg1acX52KlRtmYUlrn2BJLV1CA4OnuMw+rohc=";

  types-aiobotocore-apigatewaymanagementapi =
    buildTypesAiobotocorePackage "apigatewaymanagementapi" "2.20.0"
      "sha256-ib5+Cu3nentjRvEEWFN0tb8B8U0gb+JkMzYFuEGDDwI=";

  types-aiobotocore-apigatewayv2 =
    buildTypesAiobotocorePackage "apigatewayv2" "2.20.0"
      "sha256-CNcHXPr2olDpgQzuh2HDks3GYPvyNNGPRaqn/cfR/yM=";

  types-aiobotocore-appconfig =
    buildTypesAiobotocorePackage "appconfig" "2.20.0"
      "sha256-T5dmWMtXbRcDnsu870UQvvy/3VLAZd9zT4M9kvOwI9M=";

  types-aiobotocore-appconfigdata =
    buildTypesAiobotocorePackage "appconfigdata" "2.20.0"
      "sha256-hd2MMkzNAhJxth19wGBlk9ZzOQsZpzLv4aPHkW7JW6s=";

  types-aiobotocore-appfabric =
    buildTypesAiobotocorePackage "appfabric" "2.20.0"
      "sha256-vlCEfzWmhRohZSZg89vYLjJPXKakMVquvhduARyzuQI=";

  types-aiobotocore-appflow =
    buildTypesAiobotocorePackage "appflow" "2.20.0"
      "sha256-AsaKB7KivwLkO8KhEztIMKh0LgbKiRXipqrNO0Is9Wo=";

  types-aiobotocore-appintegrations =
    buildTypesAiobotocorePackage "appintegrations" "2.20.0"
      "sha256-Q/EwQObPe8wrbtK4HZHF2djWufOmZQohidPlfOJJe44=";

  types-aiobotocore-application-autoscaling =
    buildTypesAiobotocorePackage "application-autoscaling" "2.20.0"
      "sha256-q4FVu+AHYjo3u7u7bpbkNmnEYUwo71NLNgxriPIxP4s=";

  types-aiobotocore-application-insights =
    buildTypesAiobotocorePackage "application-insights" "2.20.0"
      "sha256-gstX0pI8swiLbJI+1pLM7Ke/MWiYW4LSpb8SbtmdkSo=";

  types-aiobotocore-applicationcostprofiler =
    buildTypesAiobotocorePackage "applicationcostprofiler" "2.20.0"
      "sha256-eIP9xJ/6sPvhkRtQU8rCjHL1thX/BO+NiCbkZWwhzA0=";

  types-aiobotocore-appmesh =
    buildTypesAiobotocorePackage "appmesh" "2.20.0"
      "sha256-4P0HidSnPdJDr8Gu7eYESz4aRrcphEeL+f/feSsqp4c=";

  types-aiobotocore-apprunner =
    buildTypesAiobotocorePackage "apprunner" "2.20.0"
      "sha256-ZmMpu0mgNlmnhuNd9bqUHKHb4KEJEJX8MaYzSZuKGJA=";

  types-aiobotocore-appstream =
    buildTypesAiobotocorePackage "appstream" "2.20.0"
      "sha256-dUJpAzSOewIc5aCFEa5A5niT9d7cMIIZBGeeuuGCfIE=";

  types-aiobotocore-appsync =
    buildTypesAiobotocorePackage "appsync" "2.20.0"
      "sha256-5/sQGHV5Hsyc3zm1QBOWC+ajkMCEKceOMtNCWYuJE3c=";

  types-aiobotocore-arc-zonal-shift =
    buildTypesAiobotocorePackage "arc-zonal-shift" "2.20.0"
      "sha256-F4lgKphRp1wic7dsR48Zs1nNA0kddu+H5M/JdmmXt+8=";

  types-aiobotocore-athena =
    buildTypesAiobotocorePackage "athena" "2.20.0"
      "sha256-u6I2IU/oGvkLTrtCqvI5aj1n30nuTmwF5lYFpL8mjxU=";

  types-aiobotocore-auditmanager =
    buildTypesAiobotocorePackage "auditmanager" "2.20.0"
      "sha256-PzTAL2DGFR6AERISyiNe+Ob40pICn5xo9QirMittphU=";

  types-aiobotocore-autoscaling =
    buildTypesAiobotocorePackage "autoscaling" "2.20.0"
      "sha256-fxN0EywiKVXAE6u33G0Cd6Ax1MeWNPzof7CQy/DbyBA=";

  types-aiobotocore-autoscaling-plans =
    buildTypesAiobotocorePackage "autoscaling-plans" "2.20.0"
      "sha256-TYgTa636ejBrb3KRIfGSMMuN3VUP0SsSBCi7UWTSUOc=";

  types-aiobotocore-backup =
    buildTypesAiobotocorePackage "backup" "2.20.0"
      "sha256-uq/LHdyPffPmG/PGwR63YDIo2HIZKBURJDQZFcEm11g=";

  types-aiobotocore-backup-gateway =
    buildTypesAiobotocorePackage "backup-gateway" "2.20.0"
      "sha256-oCuq+lcB6Wj4bvFIowNJ+Cfi89h1CEoL+gu1ZCIQBz4=";

  types-aiobotocore-backupstorage =
    buildTypesAiobotocorePackage "backupstorage" "2.13.0"
      "sha256-YUKtBdBrdwL2yqDqOovvzDPbcv/sD8JLRnKz3Oh7iSU=";

  types-aiobotocore-batch =
    buildTypesAiobotocorePackage "batch" "2.20.0"
      "sha256-YSkDFXaOhqUq6H+fA0qeM6gr6/2NAeBp0zBXgaCUH0Y=";

  types-aiobotocore-billingconductor =
    buildTypesAiobotocorePackage "billingconductor" "2.20.0"
      "sha256-+oCEPzt6G/ipRyvcW5iGstf/UYK8g18e4KIkNw5BRg8=";

  types-aiobotocore-braket =
    buildTypesAiobotocorePackage "braket" "2.20.0"
      "sha256-++9LemgRH8dpgOGU/kMH+32BU0qAm5aNnGbi5Sb1ru4=";

  types-aiobotocore-budgets =
    buildTypesAiobotocorePackage "budgets" "2.20.0"
      "sha256-I77OzK8+3w8K95mQ4oLuKgUegzRPWVv/DQAZ17q/G6Y=";

  types-aiobotocore-ce =
    buildTypesAiobotocorePackage "ce" "2.20.0"
      "sha256-VlepzXzG2WgsWBSq25fzLr6lywQbK6g/rrnn7Qlb7us=";

  types-aiobotocore-chime =
    buildTypesAiobotocorePackage "chime" "2.20.0"
      "sha256-9cT4gnGJY9B/HnCbeizjiQ01ugEiNAJSmu/bEOZuzO8=";

  types-aiobotocore-chime-sdk-identity =
    buildTypesAiobotocorePackage "chime-sdk-identity" "2.20.0"
      "sha256-A0Q//lAIjzZziJU4kDxiUMyELDU/csHQ/VC6EeRVI/w=";

  types-aiobotocore-chime-sdk-media-pipelines =
    buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "2.20.0"
      "sha256-WtB9HTWZs8GH8EMUqwNZFwLG4PHwXQcyg4qI3NktWRE=";

  types-aiobotocore-chime-sdk-meetings =
    buildTypesAiobotocorePackage "chime-sdk-meetings" "2.20.0"
      "sha256-dpPs0+NxQegoDUYVIlvg3DV7QML28qlhww2qOGUQRsY=";

  types-aiobotocore-chime-sdk-messaging =
    buildTypesAiobotocorePackage "chime-sdk-messaging" "2.20.0"
      "sha256-spOwkobXyYYmhjM4ICQX/wUa6E3GfiMr4wlEVRW4cs0=";

  types-aiobotocore-chime-sdk-voice =
    buildTypesAiobotocorePackage "chime-sdk-voice" "2.20.0"
      "sha256-EPfmnUPrQH4MFz5Peib45IyVfJ57FCtni0N/tUOOeyQ=";

  types-aiobotocore-cleanrooms =
    buildTypesAiobotocorePackage "cleanrooms" "2.20.0"
      "sha256-enDjxEP+FnQ6mX/2HTNo19CVUIt/7rzORHuMupzJHCo=";

  types-aiobotocore-cloud9 =
    buildTypesAiobotocorePackage "cloud9" "2.20.0"
      "sha256-aMctd5zSSGac96JPHvXj/txVt6ZFVDjaBASwUGe5lGs=";

  types-aiobotocore-cloudcontrol =
    buildTypesAiobotocorePackage "cloudcontrol" "2.20.0"
      "sha256-lkfB7hNXGJM+PSgBEh0SaJxLmXKAkjrrf4SpRwWzIzk=";

  types-aiobotocore-clouddirectory =
    buildTypesAiobotocorePackage "clouddirectory" "2.20.0"
      "sha256-yDseRXU/pAmVT1ARriIb6/FfxircDenj5R8mCGrj7Nw=";

  types-aiobotocore-cloudformation =
    buildTypesAiobotocorePackage "cloudformation" "2.20.0"
      "sha256-vhfjpqElApVz40+1XX9tGdvINrLKE41PXCWRbpeiGlI=";

  types-aiobotocore-cloudfront =
    buildTypesAiobotocorePackage "cloudfront" "2.20.0"
      "sha256-CuzQXjfU28kmNI+uBgPSuaMS631vk8pWJ3ONKsdorOs=";

  types-aiobotocore-cloudhsm =
    buildTypesAiobotocorePackage "cloudhsm" "2.20.0"
      "sha256-gLPnf6m7FgRl/yKTzsa2WzJzsqcLgIRwdpIrSY8S8ic=";

  types-aiobotocore-cloudhsmv2 =
    buildTypesAiobotocorePackage "cloudhsmv2" "2.20.0"
      "sha256-aTNQp6XFtqyg3QJui7WpLr6DtLk+9eecpM2S8hKULNo=";

  types-aiobotocore-cloudsearch =
    buildTypesAiobotocorePackage "cloudsearch" "2.20.0"
      "sha256-tLo8dlXrUe2tAmv8o92DXqO3QFRlS/nfLR1ESfxQL3w=";

  types-aiobotocore-cloudsearchdomain =
    buildTypesAiobotocorePackage "cloudsearchdomain" "2.20.0"
      "sha256-Z0/YxMIOA73zE1JVlDCUe0iBACNp/d3w785jCsRDmz8=";

  types-aiobotocore-cloudtrail =
    buildTypesAiobotocorePackage "cloudtrail" "2.20.0"
      "sha256-LffeVqPwu0LUTi4km7tod6yE/7sw5KMGddSChh1fZ/s=";

  types-aiobotocore-cloudtrail-data =
    buildTypesAiobotocorePackage "cloudtrail-data" "2.20.0"
      "sha256-JXXVJYhTKplAainfrIJ/XS9RvZ/NaYr6Tx1NhT/P8A4=";

  types-aiobotocore-cloudwatch =
    buildTypesAiobotocorePackage "cloudwatch" "2.20.0"
      "sha256-UyHLynVQGjxtjjuXt9Ma/ChKbBgb2DId1UONXbvF6fE=";

  types-aiobotocore-codeartifact =
    buildTypesAiobotocorePackage "codeartifact" "2.20.0"
      "sha256-mEGJI2eSSe8fmjwJfVcU2XCuEhPLm+h1zaIfPi4Vh1A=";

  types-aiobotocore-codebuild =
    buildTypesAiobotocorePackage "codebuild" "2.20.0"
      "sha256-xk796/4fRlG+mXrZGLqdeWJMRUHwmrnynbbHg6dPos0=";

  types-aiobotocore-codecatalyst =
    buildTypesAiobotocorePackage "codecatalyst" "2.20.0"
      "sha256-mCkU5gdKMstk4xCz4rMgr4AkI7WYjVX097dWF4QwsCE=";

  types-aiobotocore-codecommit =
    buildTypesAiobotocorePackage "codecommit" "2.20.0"
      "sha256-Iwidfm6pCGsjEZqqijzWf1qvAPYnwbm1ktYpfe8fyqc=";

  types-aiobotocore-codedeploy =
    buildTypesAiobotocorePackage "codedeploy" "2.20.0"
      "sha256-ogqXPaMClT/wUKmEi5bIAVfSFNufJcFYaKlzbwa+9LE=";

  types-aiobotocore-codeguru-reviewer =
    buildTypesAiobotocorePackage "codeguru-reviewer" "2.20.0"
      "sha256-5y8fLD3r4yTDCGgzAVtQMpm0t557JDRgfAAK/TqQddU=";

  types-aiobotocore-codeguru-security =
    buildTypesAiobotocorePackage "codeguru-security" "2.20.0"
      "sha256-K1OnmCPaCqTjxjbQml4Px8M8pbbL34xwOfUrLod+lcU=";

  types-aiobotocore-codeguruprofiler =
    buildTypesAiobotocorePackage "codeguruprofiler" "2.20.0"
      "sha256-ICnJyQu+AIixf0JuJn/Xe058kz/jRoEWkKSu/Xcre0g=";

  types-aiobotocore-codepipeline =
    buildTypesAiobotocorePackage "codepipeline" "2.20.0"
      "sha256-M7Ry+BJ1h1QozRrhu+Q7HRnCN/7AKtkIxmvyNc4oJHU=";

  types-aiobotocore-codestar =
    buildTypesAiobotocorePackage "codestar" "2.13.3"
      "sha256-Z1ewx2RjmxbOQZ7wXaN54PVOuRs6LP3rMpsrVTacwjo=";

  types-aiobotocore-codestar-connections =
    buildTypesAiobotocorePackage "codestar-connections" "2.20.0"
      "sha256-rxcXsBx+52PQP4EFPX2XzJ6UM979m9Csg2aWxLHz6zI=";

  types-aiobotocore-codestar-notifications =
    buildTypesAiobotocorePackage "codestar-notifications" "2.20.0"
      "sha256-bMy+5c1jBJUZ8P1X3+0TvdBFg5rO8lUFcPEHkZBr8kA=";

  types-aiobotocore-cognito-identity =
    buildTypesAiobotocorePackage "cognito-identity" "2.20.0"
      "sha256-U3Hbgdo74yQd55toweGvt6WrmHVRz4HFMPUAeh/o88g=";

  types-aiobotocore-cognito-idp =
    buildTypesAiobotocorePackage "cognito-idp" "2.20.0"
      "sha256-fqHPI9NlpJ78tb0In8nC5OuiQGoKCqnJKmskED1ozZc=";

  types-aiobotocore-cognito-sync =
    buildTypesAiobotocorePackage "cognito-sync" "2.20.0"
      "sha256-2yceL/BfvtMh9cNYKtuCWLjZVuDaASkkKHu/u4qhXD8=";

  types-aiobotocore-comprehend =
    buildTypesAiobotocorePackage "comprehend" "2.20.0"
      "sha256-d/w0V7mAcEDdTop+8yDntyshVBrHraJXdJIf6tlDp8w=";

  types-aiobotocore-comprehendmedical =
    buildTypesAiobotocorePackage "comprehendmedical" "2.20.0"
      "sha256-HVHNI4zWIOVurH8XH5VUBMhXG7CmNIz8nJUnq8KObos=";

  types-aiobotocore-compute-optimizer =
    buildTypesAiobotocorePackage "compute-optimizer" "2.20.0"
      "sha256-YL6ZDMwj9pvTKUroSJl+lIIUuChjgCdwvs6RaOxNrxE=";

  types-aiobotocore-config =
    buildTypesAiobotocorePackage "config" "2.20.0"
      "sha256-qY8CopGXoEcJFCdZAjY4K4j1wSLJDvOG6zCFoiBp4E0=";

  types-aiobotocore-connect =
    buildTypesAiobotocorePackage "connect" "2.20.0"
      "sha256-70ZJMAj8jla0UPsl0rrnW+kt1pOIzvpnUG6aVwk27lc=";

  types-aiobotocore-connect-contact-lens =
    buildTypesAiobotocorePackage "connect-contact-lens" "2.20.0"
      "sha256-wCcf7ypEQO6WNK6vCTEidzsxn8b7dVJCd0ZI0233iaw=";

  types-aiobotocore-connectcampaigns =
    buildTypesAiobotocorePackage "connectcampaigns" "2.20.0"
      "sha256-pBp1Mr+3aGdVQ7AzleUXjtksNC/XP8vW3TePyyCrUgs=";

  types-aiobotocore-connectcases =
    buildTypesAiobotocorePackage "connectcases" "2.20.0"
      "sha256-Ehq4CbNi3NATHaR9UqezuFJ5+87kQh86Mp6Z8NRXwHA=";

  types-aiobotocore-connectparticipant =
    buildTypesAiobotocorePackage "connectparticipant" "2.20.0"
      "sha256-VxzNar9opMEAmpQR1+tWcNqEr72Vr4FdlMMyT8zjOpk=";

  types-aiobotocore-controltower =
    buildTypesAiobotocorePackage "controltower" "2.20.0"
      "sha256-WORtI22SvNOzKutrBl2afdLkzdS58PXTwrFl31DHNQI=";

  types-aiobotocore-cur =
    buildTypesAiobotocorePackage "cur" "2.20.0"
      "sha256-EIWUe18DnPomHD9XXQqvSgPeJbOy2Cb6wIKBMhXKMMU=";

  types-aiobotocore-customer-profiles =
    buildTypesAiobotocorePackage "customer-profiles" "2.20.0"
      "sha256-Clkz4k8g+6SD4ShY1a3COwnG7C4bdEvYKhQL9qH7yMA=";

  types-aiobotocore-databrew =
    buildTypesAiobotocorePackage "databrew" "2.20.0"
      "sha256-bILb/CcHMDmMRdggz102UKBktjJTfEgY7nId5/ELDrw=";

  types-aiobotocore-dataexchange =
    buildTypesAiobotocorePackage "dataexchange" "2.20.0"
      "sha256-zLbFXQY6HmWC3dHIRVWleaguYmkzh1dZ3nqGr2x9N28=";

  types-aiobotocore-datapipeline =
    buildTypesAiobotocorePackage "datapipeline" "2.20.0"
      "sha256-1lnisbiLaXWYGUMpd5jU5GvhW2VVcG6dGww4+E9GR6M=";

  types-aiobotocore-datasync =
    buildTypesAiobotocorePackage "datasync" "2.20.0"
      "sha256-/vmm1Z/7Kxqog0cQVxsherCfEoUiTA1fx5ujI8uf19U=";

  types-aiobotocore-dax =
    buildTypesAiobotocorePackage "dax" "2.20.0"
      "sha256-i7snlma0KPMFolNThgT6VWgU7DKFfuZx57TvD8xyhLg=";

  types-aiobotocore-detective =
    buildTypesAiobotocorePackage "detective" "2.20.0"
      "sha256-FjslyxiIJy7R+Pgs0au15f/VZQnomDWrrRBJmicIFZs=";

  types-aiobotocore-devicefarm =
    buildTypesAiobotocorePackage "devicefarm" "2.20.0"
      "sha256-ucBtUP4VSzOrzlNbpp9XwVy3wPIsDxkX9t8Q3nZcYSs=";

  types-aiobotocore-devops-guru =
    buildTypesAiobotocorePackage "devops-guru" "2.20.0"
      "sha256-S9mHI+rHhWohFRCZEDAlvBg6j2Xo47Kyj+qjb2iFfNw=";

  types-aiobotocore-directconnect =
    buildTypesAiobotocorePackage "directconnect" "2.20.0"
      "sha256-R9PsVw/fNxd1MgYeBcsfytjbB1FSQWoZcLdSXp1fTfE=";

  types-aiobotocore-discovery =
    buildTypesAiobotocorePackage "discovery" "2.20.0"
      "sha256-97ygwrteeE5O16hiSekEo2r3EWEaP0Y9N9qoHg2oOzU=";

  types-aiobotocore-dlm =
    buildTypesAiobotocorePackage "dlm" "2.20.0"
      "sha256-5AG54V7inNU4BtbAKsXFrEUf/u8j5Lusv4Hv3Qr9m/Y=";

  types-aiobotocore-dms =
    buildTypesAiobotocorePackage "dms" "2.20.0"
      "sha256-t3eYVfDe5ZF2ivX596GkePwU1IGb68wEWZMuz7Yf4k8=";

  types-aiobotocore-docdb =
    buildTypesAiobotocorePackage "docdb" "2.20.0"
      "sha256-ovey0oapnkUhHd2nEG9iNAdwo5cl/Rmqb71IqgeeAL8=";

  types-aiobotocore-docdb-elastic =
    buildTypesAiobotocorePackage "docdb-elastic" "2.20.0"
      "sha256-XGmXHIkVAbswSY9cI63amHsMA4ELZItmoHRHLIRUlXA=";

  types-aiobotocore-drs =
    buildTypesAiobotocorePackage "drs" "2.20.0"
      "sha256-h+GpZ4ohb7bgA1ojC2i9VYM/SAT11icvCUjv0gtQINA=";

  types-aiobotocore-ds =
    buildTypesAiobotocorePackage "ds" "2.20.0"
      "sha256-SAwRwMKKzC7L0Z7UM0M9nhUhvvXGUNjKdyd/LL0gyWE=";

  types-aiobotocore-dynamodb =
    buildTypesAiobotocorePackage "dynamodb" "2.20.0"
      "sha256-t5XfbxLBSLnm8P0tAM65k51qCtxBTZYuTr91bbiF2wE=";

  types-aiobotocore-dynamodbstreams =
    buildTypesAiobotocorePackage "dynamodbstreams" "2.20.0"
      "sha256-LnYIcctutaCNxTBxk/H6L74UJ6v1Eufjrp6BTtZR4f4=";

  types-aiobotocore-ebs =
    buildTypesAiobotocorePackage "ebs" "2.20.0"
      "sha256-OR6Q8ZU9qIuF6rTjj6GohHqwpvUZfMcCEYfgFcyxavM=";

  types-aiobotocore-ec2 =
    buildTypesAiobotocorePackage "ec2" "2.20.0"
      "sha256-BHPE1pfvR8M5JEuEFmUl82f2puGqmbqcxozArrIUkss=";

  types-aiobotocore-ec2-instance-connect =
    buildTypesAiobotocorePackage "ec2-instance-connect" "2.20.0"
      "sha256-vS7dYAKGc+sw9/xwFT0IHHSD2wazUVA1WIJiYjozcYk=";

  types-aiobotocore-ecr =
    buildTypesAiobotocorePackage "ecr" "2.20.0"
      "sha256-hgCKaNs5Uto3OBnObrHDAqrWvOvzDAnT1UxKMSTQr/0=";

  types-aiobotocore-ecr-public =
    buildTypesAiobotocorePackage "ecr-public" "2.20.0"
      "sha256-bG+yi6BvIixQgthiK2F65XIVe2k8iCerK/Z8ZTDCjHw=";

  types-aiobotocore-ecs =
    buildTypesAiobotocorePackage "ecs" "2.20.0"
      "sha256-41WXzFG+px3lu5Oc+/jXXcLSwwrwCePgGxB6WKM2rZE=";

  types-aiobotocore-efs =
    buildTypesAiobotocorePackage "efs" "2.20.0"
      "sha256-dubemTJZPX1Jjs/fUEXeZcFJ2jqECYBVkZLhI2ptmvA=";

  types-aiobotocore-eks =
    buildTypesAiobotocorePackage "eks" "2.20.0"
      "sha256-ZsoivOZ7amqpnuHashoLFkdFxLyNICkRNPbSIovsrGc=";

  types-aiobotocore-elastic-inference =
    buildTypesAiobotocorePackage "elastic-inference" "2.20.0"
      "sha256-jFSY7JBVjDQi6dCqlX2LG7jxpSKfILv3XWbYidvtGos=";

  types-aiobotocore-elasticache =
    buildTypesAiobotocorePackage "elasticache" "2.20.0"
      "sha256-TMCJ8uWyqsO2aUFI4e5Yjqg15kxV7m4yAGTzTsMb+j8=";

  types-aiobotocore-elasticbeanstalk =
    buildTypesAiobotocorePackage "elasticbeanstalk" "2.20.0"
      "sha256-1jDNotQ9B1iIP030bfd93gYh/PnI4oaVmCWRL9XVZy0=";

  types-aiobotocore-elastictranscoder =
    buildTypesAiobotocorePackage "elastictranscoder" "2.20.0"
      "sha256-8aEsZOx6wgq+0iq8yo5TyTJXKMKezQlAcUT9PuvF07E=";

  types-aiobotocore-elb =
    buildTypesAiobotocorePackage "elb" "2.20.0"
      "sha256-YpyaXQbohSRy4ugqZAfmHi4N3cvlj2g/3POfuowpRPI=";

  types-aiobotocore-elbv2 =
    buildTypesAiobotocorePackage "elbv2" "2.20.0"
      "sha256-cl2Z0B1IZGGJtiLu+xxwAwOdL0CSv9osSp6x4cBFWA4=";

  types-aiobotocore-emr =
    buildTypesAiobotocorePackage "emr" "2.20.0"
      "sha256-YmmVnP/YmDuBY8NcrRDDjhHYF+aWmaBvBC+R8CwIAeg=";

  types-aiobotocore-emr-containers =
    buildTypesAiobotocorePackage "emr-containers" "2.20.0"
      "sha256-T4qjEJ3u+EjqwNavTrH46xcUPqi5gTeEPN+rhvRF4co=";

  types-aiobotocore-emr-serverless =
    buildTypesAiobotocorePackage "emr-serverless" "2.20.0"
      "sha256-z2QwD4fKeC9Qp8GzUlqPVEvDerS4tyMBT8hdlVn1Px8=";

  types-aiobotocore-entityresolution =
    buildTypesAiobotocorePackage "entityresolution" "2.20.0"
      "sha256-qzFps+jqLne8I6UDcyeQzpVtrwZAjiBpkgUKCVqGvA0=";

  types-aiobotocore-es =
    buildTypesAiobotocorePackage "es" "2.20.0"
      "sha256-U4Qymfd2fxB7skmATDE03jiWjsYcmbgkJp7qFlDCkaQ=";

  types-aiobotocore-events =
    buildTypesAiobotocorePackage "events" "2.20.0"
      "sha256-ZCXbYMzoc0P/JrLr+PNyQAnG2wsVgLeKxGskcWeczn4=";

  types-aiobotocore-evidently =
    buildTypesAiobotocorePackage "evidently" "2.20.0"
      "sha256-ZGDBZSEv/c2LVp7huACyTOY/DJ2A+Uquyw2ANCDVsqY=";

  types-aiobotocore-finspace =
    buildTypesAiobotocorePackage "finspace" "2.20.0"
      "sha256-1p4KRQXRVsDtyxFUwH1Dirjh666/s5zBpnIhfIIJRnY=";

  types-aiobotocore-finspace-data =
    buildTypesAiobotocorePackage "finspace-data" "2.20.0"
      "sha256-ZzyobwR8kr8AvKXiMKhcQB7B9f5VGRYVrQyOxWmNK5E=";

  types-aiobotocore-firehose =
    buildTypesAiobotocorePackage "firehose" "2.20.0"
      "sha256-nWqbnhixL6gA5ULgyRWjGZAa0o3ulRKbisFbY9M6o+M=";

  types-aiobotocore-fis =
    buildTypesAiobotocorePackage "fis" "2.20.0"
      "sha256-e6dOdz7Bu6WY2SLxm4LHntf/M45aSkAtNxsc3WDPlFg=";

  types-aiobotocore-fms =
    buildTypesAiobotocorePackage "fms" "2.20.0"
      "sha256-b1Vb+xwuhXmisGLzxPV7CFWiWE4oWoRB8XeaZF/5jrQ=";

  types-aiobotocore-forecast =
    buildTypesAiobotocorePackage "forecast" "2.20.0"
      "sha256-qto7fTlnYfFxvRd8+3h/Iggtg4fwx7JAQB1xFcnJ1/k=";

  types-aiobotocore-forecastquery =
    buildTypesAiobotocorePackage "forecastquery" "2.20.0"
      "sha256-z/YGhlKYb3yWlYaApQWZnknVVXe5fF9VQRmYqqJyAL8=";

  types-aiobotocore-frauddetector =
    buildTypesAiobotocorePackage "frauddetector" "2.20.0"
      "sha256-tn/X+K2S/Fpjzth9dK0LtXG1G1hnoKVr22n3DO84NAk=";

  types-aiobotocore-fsx =
    buildTypesAiobotocorePackage "fsx" "2.20.0"
      "sha256-TsDrX4qSVLyiSGO3cV6lVDkFwOwSVB1po7lx2iQraWY=";

  types-aiobotocore-gamelift =
    buildTypesAiobotocorePackage "gamelift" "2.20.0"
      "sha256-26dECx0yfNXuZ4uqcL13HlwXtWDFnpGmOmqG6+biUXo=";

  types-aiobotocore-gamesparks =
    buildTypesAiobotocorePackage "gamesparks" "2.7.0"
      "sha256-oVbKtuLMPpCQcZYx/cH1Dqjv/t6/uXsveflfFVqfN+8=";

  types-aiobotocore-glacier =
    buildTypesAiobotocorePackage "glacier" "2.20.0"
      "sha256-d1FYOHaXny3AQoe7uoUc0x7SwSSXGA3lvb2pBUqh3W8=";

  types-aiobotocore-globalaccelerator =
    buildTypesAiobotocorePackage "globalaccelerator" "2.20.0"
      "sha256-AweH4olGjsrYJBUj/Y77UP/Ap4zgSuzwFTV8pEF9e2Y=";

  types-aiobotocore-glue =
    buildTypesAiobotocorePackage "glue" "2.20.0"
      "sha256-dqItO7meVtFDVRrDjblz/1ciy7wP69/OcuM0pQLgv90=";

  types-aiobotocore-grafana =
    buildTypesAiobotocorePackage "grafana" "2.20.0"
      "sha256-fmFvHEKJ5YQcmrxFvsRPNm8CLJpyz9lx5uyUGv+8QWU=";

  types-aiobotocore-greengrass =
    buildTypesAiobotocorePackage "greengrass" "2.20.0"
      "sha256-gyXeAJSRTP0mVfvNQV4RnCMhXfguN9A4WVoGIKhusVE=";

  types-aiobotocore-greengrassv2 =
    buildTypesAiobotocorePackage "greengrassv2" "2.20.0"
      "sha256-yjFZjEjlP0lsBZJODaECOmHsrkCSsAysc1Dcv+evmQw=";

  types-aiobotocore-groundstation =
    buildTypesAiobotocorePackage "groundstation" "2.20.0"
      "sha256-cjtnt1jylvQYQ/EkfQdpJc5QWUQZ9RgiPiznJqmnv4g=";

  types-aiobotocore-guardduty =
    buildTypesAiobotocorePackage "guardduty" "2.20.0"
      "sha256-ptlpnIwNt7qk/qf2vfAD8sF1WCRiq+t7N5qvI0Pg3O4=";

  types-aiobotocore-health =
    buildTypesAiobotocorePackage "health" "2.20.0"
      "sha256-wmsFOLFnY8tk+bGpfvPPDcJ1Q97dh0Jy95cHuXU/8P8=";

  types-aiobotocore-healthlake =
    buildTypesAiobotocorePackage "healthlake" "2.20.0"
      "sha256-eT6AAo+YpJ2fOy1UQDAXaQXCQ4VJCJK3XOxC2gXVEDU=";

  types-aiobotocore-honeycode =
    buildTypesAiobotocorePackage "honeycode" "2.13.0"
      "sha256-DeeheoQeFEcDH21DSNs2kSR1rjnPLtTgz0yNCFnE+Io=";

  types-aiobotocore-iam =
    buildTypesAiobotocorePackage "iam" "2.20.0"
      "sha256-W1GvpQVqe4/kGG+PIBuGtt5YNJ7GHD+JAHj0uNBVaeU=";

  types-aiobotocore-identitystore =
    buildTypesAiobotocorePackage "identitystore" "2.20.0"
      "sha256-ij8mbI/Fknd4w8Urclp0D+7bakLmN/l1Og5glKIuKYg=";

  types-aiobotocore-imagebuilder =
    buildTypesAiobotocorePackage "imagebuilder" "2.20.0"
      "sha256-3gHKvfhARYSu5PIibkdgI1x4EHYyQcwQg5MSBEMBOOU=";

  types-aiobotocore-importexport =
    buildTypesAiobotocorePackage "importexport" "2.20.0"
      "sha256-CjaRy2u4V3PAirAsiZhzbeG8jFAmVqojdWjNw4SGZ+c=";

  types-aiobotocore-inspector =
    buildTypesAiobotocorePackage "inspector" "2.20.0"
      "sha256-BEJDgai+M2mpq7PedJGCTkgh0mmNqQ3cVF1U0qDEpgc=";

  types-aiobotocore-inspector2 =
    buildTypesAiobotocorePackage "inspector2" "2.20.0"
      "sha256-/2QmKhWaQkt3YvMIKOT4OC9dZ00prfX1c7/9bRdDJbg=";

  types-aiobotocore-internetmonitor =
    buildTypesAiobotocorePackage "internetmonitor" "2.20.0"
      "sha256-IkczF80SOUAodn6+SivGWEBOHWt+vtnYh+DC+r+UCn8=";

  types-aiobotocore-iot =
    buildTypesAiobotocorePackage "iot" "2.20.0"
      "sha256-PocsNcHolk4IZnIq94BAMOGWSxx3tNekY0aNQQ3ioy4=";

  types-aiobotocore-iot-data =
    buildTypesAiobotocorePackage "iot-data" "2.20.0"
      "sha256-boxNLBzxQXFcfxfPTy5ER4PVNphf6qaYBqwBBXJEgPM=";

  types-aiobotocore-iot-jobs-data =
    buildTypesAiobotocorePackage "iot-jobs-data" "2.20.0"
      "sha256-fWMuH8Xd5MRA/BUd2iWQVUKlVV3SguhNRKwESukm2CI=";

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
    buildTypesAiobotocorePackage "iotanalytics" "2.20.0"
      "sha256-ogIh2FrDGLYT44clgZyXnAd4A6fUFbClQDSwSstPvj0=";

  types-aiobotocore-iotdeviceadvisor =
    buildTypesAiobotocorePackage "iotdeviceadvisor" "2.20.0"
      "sha256-aCxmkNHt8PqaNWzgwN4NMuKnyKihhyv1iPGsHTWyAEk=";

  types-aiobotocore-iotevents =
    buildTypesAiobotocorePackage "iotevents" "2.20.0"
      "sha256-QajRjqUzQyB0two8cAakR/SdiPukZcQbj9aQoFQGEz4=";

  types-aiobotocore-iotevents-data =
    buildTypesAiobotocorePackage "iotevents-data" "2.20.0"
      "sha256-KovY4lb/tPxnXcWc21Y/9aiWPKb1O6ARZj/zbN878NM=";

  types-aiobotocore-iotfleethub =
    buildTypesAiobotocorePackage "iotfleethub" "2.20.0"
      "sha256-rVWL+d1oA13A7J9fRTqJzBXrZIHwE9h6p70+w/kYVjM=";

  types-aiobotocore-iotfleetwise =
    buildTypesAiobotocorePackage "iotfleetwise" "2.20.0"
      "sha256-QYmVadffYEPyTKEq19lYTMSOY7Z7fVbsY25vMzvCEpU=";

  types-aiobotocore-iotsecuretunneling =
    buildTypesAiobotocorePackage "iotsecuretunneling" "2.20.0"
      "sha256-xjpmcB2Nf+HpGQO53lxzElRgGOTkfz7rNLRRGic+T10=";

  types-aiobotocore-iotsitewise =
    buildTypesAiobotocorePackage "iotsitewise" "2.20.0"
      "sha256-1UyTtwHiE+pcbi4R5JYIc1CCJaCY5miHnJwf5za5AdY=";

  types-aiobotocore-iotthingsgraph =
    buildTypesAiobotocorePackage "iotthingsgraph" "2.20.0"
      "sha256-4btZX56/OhBm0iloRABhcD8Mi86WMX3iWiicKjsMPYE=";

  types-aiobotocore-iottwinmaker =
    buildTypesAiobotocorePackage "iottwinmaker" "2.20.0"
      "sha256-qLR2g60NOBx4nJATDsXcq32+RxeTRSduX6SJ3zrtdwI=";

  types-aiobotocore-iotwireless =
    buildTypesAiobotocorePackage "iotwireless" "2.20.0"
      "sha256-Su8DoUFzKbvOj2RT6TgeINivsgGvPzjyWRD4owQOXzo=";

  types-aiobotocore-ivs =
    buildTypesAiobotocorePackage "ivs" "2.20.0"
      "sha256-rEd/HiptXs0+aTdYlLUIE7niLb/nvTd0ZVpKOw/9CXY=";

  types-aiobotocore-ivs-realtime =
    buildTypesAiobotocorePackage "ivs-realtime" "2.20.0"
      "sha256-E3jBv+YJJkaG7aRtjP0sToVpqVTARxsXViQqe9rdwbU=";

  types-aiobotocore-ivschat =
    buildTypesAiobotocorePackage "ivschat" "2.20.0"
      "sha256-BdPKGVCkUcnpXk0O3ACj25C3cyhlL5CUv0clU/zDxhw=";

  types-aiobotocore-kafka =
    buildTypesAiobotocorePackage "kafka" "2.20.0"
      "sha256-fzahRxuwt22W0OEKvlDEROqDOjDO6ngV8GQdnVYm8hw=";

  types-aiobotocore-kafkaconnect =
    buildTypesAiobotocorePackage "kafkaconnect" "2.20.0"
      "sha256-EiAO7x1I2m2P8nmtmpjL8qdRxu2XR5ySdi47a7ne94g=";

  types-aiobotocore-kendra =
    buildTypesAiobotocorePackage "kendra" "2.20.0"
      "sha256-j5JOsYs+Qgm8E9fo/SdAgZkeGTWgkotvbXpzxsG9tVs=";

  types-aiobotocore-kendra-ranking =
    buildTypesAiobotocorePackage "kendra-ranking" "2.20.0"
      "sha256-VhzCPNW94K4oijfTTfzyFkhmK9Rv7fW0vguQmwGvjjA=";

  types-aiobotocore-keyspaces =
    buildTypesAiobotocorePackage "keyspaces" "2.20.0"
      "sha256-id/WoecqTrWsjpDmgVhHs+YfPHiRmynThABN4CN5UvY=";

  types-aiobotocore-kinesis =
    buildTypesAiobotocorePackage "kinesis" "2.20.0"
      "sha256-fPkAPz4quk4OhtTg8wgi/SAWtojeLRKOnw8gLhNO8ok=";

  types-aiobotocore-kinesis-video-archived-media =
    buildTypesAiobotocorePackage "kinesis-video-archived-media" "2.20.0"
      "sha256-jBP7KnqHFKhwAfIzvbAY4cfyFAD3IpT6jPX/nrhp/pQ=";

  types-aiobotocore-kinesis-video-media =
    buildTypesAiobotocorePackage "kinesis-video-media" "2.20.0"
      "sha256-5UO+dG4EiKOSHwGY6F6/MULP+i1/PyvsINbHUTeQKZ0=";

  types-aiobotocore-kinesis-video-signaling =
    buildTypesAiobotocorePackage "kinesis-video-signaling" "2.20.0"
      "sha256-hUIZ95fG2RBZEIJYoren/Ke7ask50TCa/0XXmbTTOHM=";

  types-aiobotocore-kinesis-video-webrtc-storage =
    buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "2.20.0"
      "sha256-2Eg239y045qa2RHJ5qHqM1rCN6ffwlFLJVSbOZoeEYs=";

  types-aiobotocore-kinesisanalytics =
    buildTypesAiobotocorePackage "kinesisanalytics" "2.20.0"
      "sha256-VfUEF1XN6K17lglX4DvlopK5g3b4u5YdBWkmwxlRn+Y=";

  types-aiobotocore-kinesisanalyticsv2 =
    buildTypesAiobotocorePackage "kinesisanalyticsv2" "2.20.0"
      "sha256-35pjDOpcifpuVra7t/s54KKkgxyLk+rHcIqHlmCQX04=";

  types-aiobotocore-kinesisvideo =
    buildTypesAiobotocorePackage "kinesisvideo" "2.20.0"
      "sha256-28P0SBEBQug4LprBBL7YKf+BwgrO5STudR8zZP3ThrM=";

  types-aiobotocore-kms =
    buildTypesAiobotocorePackage "kms" "2.20.0"
      "sha256-XIgMeDgI3mnEZORc/qLQqOIH0EO8cFnqcsUtLUj65C8=";

  types-aiobotocore-lakeformation =
    buildTypesAiobotocorePackage "lakeformation" "2.20.0"
      "sha256-ROGQj6WaxUjRXDuniO3+2lRJEGZ2LSO30bA5ltNNPjk=";

  types-aiobotocore-lambda =
    buildTypesAiobotocorePackage "lambda" "2.20.0"
      "sha256-tJo52ujsTF/gsQYmbcIxgwcE4EKBo7BbgTNli+j9Xm8=";

  types-aiobotocore-lex-models =
    buildTypesAiobotocorePackage "lex-models" "2.20.0"
      "sha256-KZ0N/L7HmnH3BZRFP54GhZQzaoSYu34TcOwt/KpUJKo=";

  types-aiobotocore-lex-runtime =
    buildTypesAiobotocorePackage "lex-runtime" "2.20.0"
      "sha256-FCib33yaCNzCfaomAX+Ne+OLI349qbZuItK8CLVOj8s=";

  types-aiobotocore-lexv2-models =
    buildTypesAiobotocorePackage "lexv2-models" "2.20.0"
      "sha256-O489eSUxWPBge6MpiiSDZWJ1YfC759apLVHDqzD7gRc=";

  types-aiobotocore-lexv2-runtime =
    buildTypesAiobotocorePackage "lexv2-runtime" "2.20.0"
      "sha256-fqH/9mBUl4ncalhl/pHooLKJ0sdPUwasvO2R5L5ruLI=";

  types-aiobotocore-license-manager =
    buildTypesAiobotocorePackage "license-manager" "2.20.0"
      "sha256-r5fQtqKTgT1/DZOSAfwf0lFj6bh57NRPV+9iKUnthzA=";

  types-aiobotocore-license-manager-linux-subscriptions =
    buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "2.20.0"
      "sha256-v83X+T5VwC++t4HRluu/ih72XWTlfQmn0Xk/3O0aDPo=";

  types-aiobotocore-license-manager-user-subscriptions =
    buildTypesAiobotocorePackage "license-manager-user-subscriptions" "2.20.0"
      "sha256-1/nosyA+9LgevMeMfPImiRJTuR1nJ/dkdo6dwDiTeL0=";

  types-aiobotocore-lightsail =
    buildTypesAiobotocorePackage "lightsail" "2.20.0"
      "sha256-TjH7+dZVpbeSqZMyqB07ADozC69sFt0lJ/p17Utewu4=";

  types-aiobotocore-location =
    buildTypesAiobotocorePackage "location" "2.20.0"
      "sha256-bCcE6E2nth/ZsoeDCuflnocvEuRsuXflENWLfxSp2E4=";

  types-aiobotocore-logs =
    buildTypesAiobotocorePackage "logs" "2.20.0"
      "sha256-V7VzCpBOfx/8Y9PWVaRHeZEieAjV1n75hjdCPIw272c=";

  types-aiobotocore-lookoutequipment =
    buildTypesAiobotocorePackage "lookoutequipment" "2.20.0"
      "sha256-RJY1uw7stbB458qRJUSAndfGXcLtDKEiO7R+7VmgkN4=";

  types-aiobotocore-lookoutmetrics =
    buildTypesAiobotocorePackage "lookoutmetrics" "2.20.0"
      "sha256-r+Wr+cyQOhZfyl6MwzjudY429EwxdOWuL2r5b+11CEQ=";

  types-aiobotocore-lookoutvision =
    buildTypesAiobotocorePackage "lookoutvision" "2.20.0"
      "sha256-UR4jf79enU5kHXgRe2ZIkJ8QzXUQ8uW1eiVMyywHqSY=";

  types-aiobotocore-m2 =
    buildTypesAiobotocorePackage "m2" "2.20.0"
      "sha256-3V7KqeKxtZAkWN+vLbue1ZoxHG84r2c4rrBfPJaQj/s=";

  types-aiobotocore-machinelearning =
    buildTypesAiobotocorePackage "machinelearning" "2.20.0"
      "sha256-uyuEDId9osQe+XZuEVwjEF+qfM6HcCZaun3SC/dbF+k=";

  types-aiobotocore-macie =
    buildTypesAiobotocorePackage "macie" "2.7.0"
      "sha256-hJJtGsK2b56nKX1ZhiarC+ffyjHYWRiC8II4oyDZWWw=";

  types-aiobotocore-macie2 =
    buildTypesAiobotocorePackage "macie2" "2.20.0"
      "sha256-E8WkN4Rs3gkjmBRP46thasU1ODzNMSqOj2I8q+oRTjw=";

  types-aiobotocore-managedblockchain =
    buildTypesAiobotocorePackage "managedblockchain" "2.20.0"
      "sha256-ZgIeeL5Pa3o2CvUndV9R0qdq0DTI91HyOATBXSo4K6o=";

  types-aiobotocore-managedblockchain-query =
    buildTypesAiobotocorePackage "managedblockchain-query" "2.20.0"
      "sha256-Ok0QY4T1CsHQpaAl0vE8Rf3qRk4y6LVwPTlZFUoll5o=";

  types-aiobotocore-marketplace-catalog =
    buildTypesAiobotocorePackage "marketplace-catalog" "2.20.0"
      "sha256-JTsm6/w3tXlPfTuFflr0z0acVMJu4O1NIeELvhUhfTw=";

  types-aiobotocore-marketplace-entitlement =
    buildTypesAiobotocorePackage "marketplace-entitlement" "2.20.0"
      "sha256-sDmtqfeyjr8oa8A4ru8ncOrjqR/qAO3rLIvoNRHs7Ks=";

  types-aiobotocore-marketplacecommerceanalytics =
    buildTypesAiobotocorePackage "marketplacecommerceanalytics" "2.20.0"
      "sha256-d1rfAh6EpdMNfuPmu0nyO1kuHlS7QLKFByLuJyNRhKo=";

  types-aiobotocore-mediaconnect =
    buildTypesAiobotocorePackage "mediaconnect" "2.20.0"
      "sha256-H8wDv49xZORmYxZxsreRS83bpe1NFY2lm2zU1/PRtB8=";

  types-aiobotocore-mediaconvert =
    buildTypesAiobotocorePackage "mediaconvert" "2.20.0"
      "sha256-WD/QPBOca6JF7+zths3/4VwMHKQHRetPqazWSRibdns=";

  types-aiobotocore-medialive =
    buildTypesAiobotocorePackage "medialive" "2.20.0"
      "sha256-iT2n2+eaD5b34jIps8131QepjevFgonheBdqQW+6NH0=";

  types-aiobotocore-mediapackage =
    buildTypesAiobotocorePackage "mediapackage" "2.20.0"
      "sha256-4/tY2HUnDZM9/pGIGfLLI16Wfj/8Py/5Vc3fXg9wY5g=";

  types-aiobotocore-mediapackage-vod =
    buildTypesAiobotocorePackage "mediapackage-vod" "2.20.0"
      "sha256-e8tOOUFRKC6k/vck4OeqwO2TbE0EYcnvM5aokS2BV80=";

  types-aiobotocore-mediapackagev2 =
    buildTypesAiobotocorePackage "mediapackagev2" "2.20.0"
      "sha256-2BTKXHPocIBp/Ei0PH8TdpvrNvY4V12j6tL5x1Gk37g=";

  types-aiobotocore-mediastore =
    buildTypesAiobotocorePackage "mediastore" "2.20.0"
      "sha256-7NoLjksSvFjUvyVDUFRtFhcuTTzKPObM+SUGI51FgBE=";

  types-aiobotocore-mediastore-data =
    buildTypesAiobotocorePackage "mediastore-data" "2.20.0"
      "sha256-aZdR0xFPevmsLFynIytMAnIb0Be22mEGOTBlL192yeE=";

  types-aiobotocore-mediatailor =
    buildTypesAiobotocorePackage "mediatailor" "2.20.0"
      "sha256-eUTuAi248pZVJ7++y8rwLeNpgCk5/J9D3l6SIWRN+sU=";

  types-aiobotocore-medical-imaging =
    buildTypesAiobotocorePackage "medical-imaging" "2.20.0"
      "sha256-mxsmGcr6GF68ArL7ITbJsfysUBRRrnlqu5aOxRhv61E=";

  types-aiobotocore-memorydb =
    buildTypesAiobotocorePackage "memorydb" "2.20.0"
      "sha256-2aF85ljNLGSsC8NojoADBPc/WS3KxN1/vKrRs+7CgqY=";

  types-aiobotocore-meteringmarketplace =
    buildTypesAiobotocorePackage "meteringmarketplace" "2.20.0"
      "sha256-n4LMNgzNSut/c+4UedDDiNIbuvedEdlSmjPPY4AH+JI=";

  types-aiobotocore-mgh =
    buildTypesAiobotocorePackage "mgh" "2.20.0"
      "sha256-82VFLnwsPfAM+mUR2DD5gYBQdKX6jCYJ7F2fWUA0pdo=";

  types-aiobotocore-mgn =
    buildTypesAiobotocorePackage "mgn" "2.20.0"
      "sha256-iTytXKLa6hdAWx16ySWbPnJvyaUDNz8oTOdTEgqCwxU=";

  types-aiobotocore-migration-hub-refactor-spaces =
    buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "2.20.0"
      "sha256-fbnGCasoNqItW41QSieGqu+kqi/1hz0i6o+8gB8w/9c=";

  types-aiobotocore-migrationhub-config =
    buildTypesAiobotocorePackage "migrationhub-config" "2.20.0"
      "sha256-likLLf1BDypgTiSl0UC/zN9aSXJuXJiuitXpnpdYN24=";

  types-aiobotocore-migrationhuborchestrator =
    buildTypesAiobotocorePackage "migrationhuborchestrator" "2.20.0"
      "sha256-Z3rcqdEIn6sA6WGdhhAOo+aa6hYQQndUR7U/DHBWPVM=";

  types-aiobotocore-migrationhubstrategy =
    buildTypesAiobotocorePackage "migrationhubstrategy" "2.20.0"
      "sha256-6IdRb/SXJ5yTWhO03frGQrO2onXfCJxFC/fUXk+DexM=";

  types-aiobotocore-mobile =
    buildTypesAiobotocorePackage "mobile" "2.13.2"
      "sha256-OxB91BCAmYnY72JBWZaBlEkpAxN2Q5aY4i1Pt3eD9hc=";

  types-aiobotocore-mq =
    buildTypesAiobotocorePackage "mq" "2.20.0"
      "sha256-hmZroA6DrLZlWBD7lcllbrvayvtHGTn+4nMNIlqgA5A=";

  types-aiobotocore-mturk =
    buildTypesAiobotocorePackage "mturk" "2.20.0"
      "sha256-hzmJF8cFjLq+aApWu4UkckTHATJNr2CV1/kAWKdREkk=";

  types-aiobotocore-mwaa =
    buildTypesAiobotocorePackage "mwaa" "2.20.0"
      "sha256-JQ2FNleyZTiNDh1R7ZTX7/CKMiNOyYdS/B6FQV8QaJ8=";

  types-aiobotocore-neptune =
    buildTypesAiobotocorePackage "neptune" "2.20.0"
      "sha256-XVMGhrsZpy9hoad0FJGAafPo0KzkKwrcR+TihN5hvRs=";

  types-aiobotocore-network-firewall =
    buildTypesAiobotocorePackage "network-firewall" "2.20.0"
      "sha256-mhNNXBr7HPvv5hwmzs7642/dRLN/7wxjwi3U/jXn8Tg=";

  types-aiobotocore-networkmanager =
    buildTypesAiobotocorePackage "networkmanager" "2.20.0"
      "sha256-pFdJVZ25HS//7EOH7vsT/kIJAkN6lH38K113/AI85dc=";

  types-aiobotocore-nimble =
    buildTypesAiobotocorePackage "nimble" "2.15.2"
      "sha256-PChX5Jbgr0d1YaTZU9AbX3cM7NrhkyunK6/X3l+I8Q0=";

  types-aiobotocore-oam =
    buildTypesAiobotocorePackage "oam" "2.20.0"
      "sha256-e23SMdETLYGBMQCwh4aMAvHl8LJnu7tfw6J/o9aTXNY=";

  types-aiobotocore-omics =
    buildTypesAiobotocorePackage "omics" "2.20.0"
      "sha256-PFF4Z53AU67Ou83VGwrTV4kL9qcNM4Wx8Zg0PfpRcMg=";

  types-aiobotocore-opensearch =
    buildTypesAiobotocorePackage "opensearch" "2.20.0"
      "sha256-d4PEIPVnxk5eWb6ZOpoCy54Qn7ppIkLKqti/OEJ8YFU=";

  types-aiobotocore-opensearchserverless =
    buildTypesAiobotocorePackage "opensearchserverless" "2.20.0"
      "sha256-Lco33KX+yA3DQAFEePLxO4OhGcueNlrXEHxl3cESHWs=";

  types-aiobotocore-opsworks =
    buildTypesAiobotocorePackage "opsworks" "2.20.0"
      "sha256-jJIhEoSwYVjsUSA7ju0xC4onwo8BdVSjKp03VS9GqxY=";

  types-aiobotocore-opsworkscm =
    buildTypesAiobotocorePackage "opsworkscm" "2.20.0"
      "sha256-D4/PU5pzj9mcE9ECAWOm/eD1DJX/4sdV300shRUNFQc=";

  types-aiobotocore-organizations =
    buildTypesAiobotocorePackage "organizations" "2.20.0"
      "sha256-FcdVh42O71GMP/9zIBBe/CqiGm2BqXh9LhyjktxZFOQ=";

  types-aiobotocore-osis =
    buildTypesAiobotocorePackage "osis" "2.20.0"
      "sha256-TBdd32Z9jeNzbyyiI+zMYCqtDQb8nG53/H85uo1hjK0=";

  types-aiobotocore-outposts =
    buildTypesAiobotocorePackage "outposts" "2.20.0"
      "sha256-bV5yOLBPs7NyJ+4TICr9jCrJ+WF7SqVqGlgnl2Z1TBg=";

  types-aiobotocore-panorama =
    buildTypesAiobotocorePackage "panorama" "2.20.0"
      "sha256-M8k6UvfHFcQuiY2Q1JNNk4ayOFON0byofI3pl1aFvBU=";

  types-aiobotocore-payment-cryptography =
    buildTypesAiobotocorePackage "payment-cryptography" "2.20.0"
      "sha256-SOWMrCVjRKjfMM+CgQCFTou7JMpbAYZHRe6GE8yYTFA=";

  types-aiobotocore-payment-cryptography-data =
    buildTypesAiobotocorePackage "payment-cryptography-data" "2.20.0"
      "sha256-pImTqyS3SsDFNMLZ/82tGAN44SHK3C41Er5NhVGMdxk=";

  types-aiobotocore-personalize =
    buildTypesAiobotocorePackage "personalize" "2.20.0"
      "sha256-g5jneNH5zoE3I8xdYOoGj/WCwOCucU7qQLHa00CqfY8=";

  types-aiobotocore-personalize-events =
    buildTypesAiobotocorePackage "personalize-events" "2.20.0"
      "sha256-oSXhJhPp5n+koVLgT6WkuluddTCPKHHjBcJlhb1RwaE=";

  types-aiobotocore-personalize-runtime =
    buildTypesAiobotocorePackage "personalize-runtime" "2.20.0"
      "sha256-GFajcJGBlw9MNLwK/W7qwGmriiYwicXKsWkm5LR4OSs=";

  types-aiobotocore-pi =
    buildTypesAiobotocorePackage "pi" "2.20.0"
      "sha256-jCW+F+fQqfmaWsmETGgNX1Q1Otrc9dRR8h6yj6cWFcw=";

  types-aiobotocore-pinpoint =
    buildTypesAiobotocorePackage "pinpoint" "2.20.0"
      "sha256-DA8EdjIRsYkbb4xhwIscQy6S//QEK0uIqW444aqDuyY=";

  types-aiobotocore-pinpoint-email =
    buildTypesAiobotocorePackage "pinpoint-email" "2.20.0"
      "sha256-5z11NL8Gpw3GW1XyrvOsu83qMTLDpgpmYZSiNKotOcw=";

  types-aiobotocore-pinpoint-sms-voice =
    buildTypesAiobotocorePackage "pinpoint-sms-voice" "2.20.0"
      "sha256-bUlg8U18RHhDmpMI10H7bDPm+Xce9WSFH2ijJnlYd7k=";

  types-aiobotocore-pinpoint-sms-voice-v2 =
    buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "2.20.0"
      "sha256-DjtLOIVTA5InXbdvI/iVZeMcjKz6v37bpNRHyZkpUvo=";

  types-aiobotocore-pipes =
    buildTypesAiobotocorePackage "pipes" "2.20.0"
      "sha256-MFak78D8anrieHr/380kCv5SfYw0dsS1Uc6now9J9cw=";

  types-aiobotocore-polly =
    buildTypesAiobotocorePackage "polly" "2.20.0"
      "sha256-tYota+3yBKk7J+pQlA02IBcLQ6Ybx43Ag2uzNccejKs=";

  types-aiobotocore-pricing =
    buildTypesAiobotocorePackage "pricing" "2.20.0"
      "sha256-USJ3+goGU5a8Nnm4opu3RG9vZtvUaUJtg9LHPgEF33Y=";

  types-aiobotocore-privatenetworks =
    buildTypesAiobotocorePackage "privatenetworks" "2.20.0"
      "sha256-iAIRJd5vwKjrHFgXusbQ7BLDLBQcQNizuCNT8Glv5qg=";

  types-aiobotocore-proton =
    buildTypesAiobotocorePackage "proton" "2.20.0"
      "sha256-DijeesjClZKfVXQNpmOwz6wEsZj4iI3WcDJGNurgZWA=";

  types-aiobotocore-qldb =
    buildTypesAiobotocorePackage "qldb" "2.20.0"
      "sha256-IGj8+n8w1/X+glF09oQTTv/DaAQ3ITwJhsBOlc10EqQ=";

  types-aiobotocore-qldb-session =
    buildTypesAiobotocorePackage "qldb-session" "2.20.0"
      "sha256-93uRape044SqXwH56R7aTEl+KTDX4cU54mhrGs8uUyQ=";

  types-aiobotocore-quicksight =
    buildTypesAiobotocorePackage "quicksight" "2.20.0"
      "sha256-0zOukDBaV0vtmx922FVEtvWkKhDz0etc6wjCBewX28E=";

  types-aiobotocore-ram =
    buildTypesAiobotocorePackage "ram" "2.20.0"
      "sha256-EgB0mejJxCow+OuTTiluPmU6Ow/+t1/7ajn6/t5FC8w=";

  types-aiobotocore-rbin =
    buildTypesAiobotocorePackage "rbin" "2.20.0"
      "sha256-CN/J6GnHLBmKHBeCCLl9iPYbBpUe98ZrphhEg7f1VwQ=";

  types-aiobotocore-rds =
    buildTypesAiobotocorePackage "rds" "2.20.0"
      "sha256-OPJTXlQ2nG7Ho/kIO8uV3afRpUzdNvdj52fVJDj5o+k=";

  types-aiobotocore-rds-data =
    buildTypesAiobotocorePackage "rds-data" "2.20.0"
      "sha256-LGVzGghUQSiCCyMTxMsUSIPRvDf+Did0yHGdVO/W55k=";

  types-aiobotocore-redshift =
    buildTypesAiobotocorePackage "redshift" "2.20.0"
      "sha256-0koG8PDtZmoD1adO1egvtDXPMFEeeZHA3+LHl3+xeTQ=";

  types-aiobotocore-redshift-data =
    buildTypesAiobotocorePackage "redshift-data" "2.20.0"
      "sha256-Bz1WmvtW8/3rv5qdoSvwElLD256uAaPE+t9ybM0DEwY=";

  types-aiobotocore-redshift-serverless =
    buildTypesAiobotocorePackage "redshift-serverless" "2.20.0"
      "sha256-5aNy/DtvkM/LPjSTr3PVk6L+yYYEWKf/XeYf7VJi1rA=";

  types-aiobotocore-rekognition =
    buildTypesAiobotocorePackage "rekognition" "2.20.0"
      "sha256-PWpScOguh9fftX0D88UWoqLCPcoh4AOl3p0tzDrPu+4=";

  types-aiobotocore-resiliencehub =
    buildTypesAiobotocorePackage "resiliencehub" "2.20.0"
      "sha256-cj5Y0TIqXVwtoL+QUfEG0UtL74B+gf6MAd7YfPc+0tg=";

  types-aiobotocore-resource-explorer-2 =
    buildTypesAiobotocorePackage "resource-explorer-2" "2.20.0"
      "sha256-78D6yNTOyrA048cM15WM46kWXnzMUSMEgZY3OdFKycc=";

  types-aiobotocore-resource-groups =
    buildTypesAiobotocorePackage "resource-groups" "2.20.0"
      "sha256-INKba41+hzh+eBTjBE8iG3UlEzoHKrVMe3G+v6dhuic=";

  types-aiobotocore-resourcegroupstaggingapi =
    buildTypesAiobotocorePackage "resourcegroupstaggingapi" "2.20.0"
      "sha256-18cfFgSrmrAhCUGVpdAJ0A2FT1uHSno6ZHNvP3rFllQ=";

  types-aiobotocore-robomaker =
    buildTypesAiobotocorePackage "robomaker" "2.20.0"
      "sha256-bi2qyDLLsdokxwBlqlB5nKrKJrT2iZVf/UmcSoRJeRI=";

  types-aiobotocore-rolesanywhere =
    buildTypesAiobotocorePackage "rolesanywhere" "2.20.0"
      "sha256-Uj5J5PszOXCiP0iBAX8+EwENE9ZtC71LjwS9HWrDXmY=";

  types-aiobotocore-route53 =
    buildTypesAiobotocorePackage "route53" "2.20.0"
      "sha256-BRXgNC2+ng2G7gu62dVr2HebTpR8EZUAFGs1ahHF7Jc=";

  types-aiobotocore-route53-recovery-cluster =
    buildTypesAiobotocorePackage "route53-recovery-cluster" "2.20.0"
      "sha256-UXoQtcDi/7eF7uSQvnu7GF9uJ1SCU+8SjdlRxTMOfIU=";

  types-aiobotocore-route53-recovery-control-config =
    buildTypesAiobotocorePackage "route53-recovery-control-config" "2.20.0"
      "sha256-uFsEmvPwNydaKLYA+1CgkQGxMlG0fqeaCbIVX8qCAIY=";

  types-aiobotocore-route53-recovery-readiness =
    buildTypesAiobotocorePackage "route53-recovery-readiness" "2.20.0"
      "sha256-BKbe0z2dbzX1DhiyU+axuOLp7bjVWJdRh869P8zP5cs=";

  types-aiobotocore-route53domains =
    buildTypesAiobotocorePackage "route53domains" "2.20.0"
      "sha256-a9KWFaaTdeizg6dCpwKkw7t39kqw5E7aTxjszc4VIBY=";

  types-aiobotocore-route53resolver =
    buildTypesAiobotocorePackage "route53resolver" "2.20.0"
      "sha256-QGYjpOnxj2QHNUkO+Ct1uwLGP//EIkKfmPwKTHujCoo=";

  types-aiobotocore-rum =
    buildTypesAiobotocorePackage "rum" "2.20.0"
      "sha256-VVYsNioRbGD2AP45BNUuS7nrOFBv5nFgjkZTlSNShUY=";

  types-aiobotocore-s3 =
    buildTypesAiobotocorePackage "s3" "2.20.0"
      "sha256-ewC5ML8WUkgWHZNd4zHM0I2saPAhGLu/xgfsqxabLpE=";

  types-aiobotocore-s3control =
    buildTypesAiobotocorePackage "s3control" "2.20.0"
      "sha256-iyR5FSMyZ21Av56eVFyzQk4dU6zKlmLBeR6uVQghdFY=";

  types-aiobotocore-s3outposts =
    buildTypesAiobotocorePackage "s3outposts" "2.20.0"
      "sha256-03Vgku04YXUPNneyM0lp6O6PlEXfQdpuqkFDzx5Yjus=";

  types-aiobotocore-sagemaker =
    buildTypesAiobotocorePackage "sagemaker" "2.20.0"
      "sha256-ZT4qKB8R6vAYYi1WSk5W1W5j/pqHKj+XwaT+3f9z3Ww=";

  types-aiobotocore-sagemaker-a2i-runtime =
    buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "2.20.0"
      "sha256-Z/XcjhYrUjAnKkGipvPwUvX4N19DxQb28V7Q1Mo43NE=";

  types-aiobotocore-sagemaker-edge =
    buildTypesAiobotocorePackage "sagemaker-edge" "2.20.0"
      "sha256-/iZYoicwfqgAuSpFUQo6aOqEcqdP7GO9Qjzog0ExPuo=";

  types-aiobotocore-sagemaker-featurestore-runtime =
    buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "2.20.0"
      "sha256-t5TwHq5QL9ZaVH7GR/64KWlbYYyJMT9nzCSLOvKlOtU=";

  types-aiobotocore-sagemaker-geospatial =
    buildTypesAiobotocorePackage "sagemaker-geospatial" "2.20.0"
      "sha256-zDUy56TyhV8ACLxTQT3Sv1ofwDI0ffJXHpW87hGUe1w=";

  types-aiobotocore-sagemaker-metrics =
    buildTypesAiobotocorePackage "sagemaker-metrics" "2.20.0"
      "sha256-1I/QvS8Nt8CeA9zAukOBjgLM0LOIgHWwhYRdCLJPVhA=";

  types-aiobotocore-sagemaker-runtime =
    buildTypesAiobotocorePackage "sagemaker-runtime" "2.20.0"
      "sha256-ReNos7nVO8Eaj65Q3bLTV7eKlXacZwsKQIAoN8gdQFk=";

  types-aiobotocore-savingsplans =
    buildTypesAiobotocorePackage "savingsplans" "2.20.0"
      "sha256-j5QgD++u1Vg6SbHcvPobUysVCOcikICNzAcVdRHgjk4=";

  types-aiobotocore-scheduler =
    buildTypesAiobotocorePackage "scheduler" "2.20.0"
      "sha256-6DS82ZbOpyDVdXfXnEDhjrwDALzPix30IQp+icqkVFg=";

  types-aiobotocore-schemas =
    buildTypesAiobotocorePackage "schemas" "2.20.0"
      "sha256-Ra06AGUI8uvT+9kps9So42JpKenLnfeht25D5Dt9L6U=";

  types-aiobotocore-sdb =
    buildTypesAiobotocorePackage "sdb" "2.20.0"
      "sha256-P0JhMqruh02GXsbh4U91s3orjGDeNGNTTE1SA6vhIYY=";

  types-aiobotocore-secretsmanager =
    buildTypesAiobotocorePackage "secretsmanager" "2.20.0"
      "sha256-RcY3tZa0h6IMbLWYl6IAkBCuLPK0Sl4txQQfvFkp5pQ=";

  types-aiobotocore-securityhub =
    buildTypesAiobotocorePackage "securityhub" "2.20.0"
      "sha256-bovP6dwLG2lBM+nOSes67zCvH85JiUv6ZLpGbQ9ynrw=";

  types-aiobotocore-securitylake =
    buildTypesAiobotocorePackage "securitylake" "2.20.0"
      "sha256-SUpQ0W+xtiUYm8Jiyaf/abuhyNtuD210cD90nOGXpmY=";

  types-aiobotocore-serverlessrepo =
    buildTypesAiobotocorePackage "serverlessrepo" "2.20.0"
      "sha256-SQCMAfD4fyZsZpxJl8V22cTBi70TCJBjU5dEyMfkVyQ=";

  types-aiobotocore-service-quotas =
    buildTypesAiobotocorePackage "service-quotas" "2.20.0"
      "sha256-KpY0ZQCo9umn0s4IV+FA1QVHS/nvQC6AhwBQJCnyvgk=";

  types-aiobotocore-servicecatalog =
    buildTypesAiobotocorePackage "servicecatalog" "2.20.0"
      "sha256-noqEo66+WGBuFI6RtPpaEF8cA9VAp8LXcMhaHCCLCdA=";

  types-aiobotocore-servicecatalog-appregistry =
    buildTypesAiobotocorePackage "servicecatalog-appregistry" "2.20.0"
      "sha256-pawtwL7mwqVtefhCT5BvbOMybsvNU/iVoElYSbbDfHc=";

  types-aiobotocore-servicediscovery =
    buildTypesAiobotocorePackage "servicediscovery" "2.20.0"
      "sha256-sWrDczkdOz4YI3SRQqMm6IibN+/mORtBT+hKrOnSbjQ=";

  types-aiobotocore-ses =
    buildTypesAiobotocorePackage "ses" "2.20.0"
      "sha256-krKHV2B6TYdUCvT5/e7kU7jsSqrnzokFMwFYUgbrdhE=";

  types-aiobotocore-sesv2 =
    buildTypesAiobotocorePackage "sesv2" "2.20.0"
      "sha256-m5D5XouRNhB6iVBaP6tf+aHqHXqlq732l0Y4o9aZIQs=";

  types-aiobotocore-shield =
    buildTypesAiobotocorePackage "shield" "2.20.0"
      "sha256-ScM208vZfGaXnROfIs/yU/OLRjHYd9jdBg0l0tvkIMk=";

  types-aiobotocore-signer =
    buildTypesAiobotocorePackage "signer" "2.20.0"
      "sha256-t8olgToS9pJmCXsXF0ZOQOQIEpxTJm/y5Db5RHv5ayI=";

  types-aiobotocore-simspaceweaver =
    buildTypesAiobotocorePackage "simspaceweaver" "2.20.0"
      "sha256-FT7/jpDFA1E2vdefvhrU1nQ7S63MC95ogzc9eFdvdYo=";

  types-aiobotocore-sms =
    buildTypesAiobotocorePackage "sms" "2.20.0"
      "sha256-pKGJ84vSXz0P04N9AT45f3kzn7lxyBWy8uB9P5l5Owc=";

  types-aiobotocore-sms-voice =
    buildTypesAiobotocorePackage "sms-voice" "2.20.0"
      "sha256-bA52BXalRbuuJggr3UDZDRZXgKqOC1I4nc+3J6AGdIY=";

  types-aiobotocore-snow-device-management =
    buildTypesAiobotocorePackage "snow-device-management" "2.20.0"
      "sha256-KebGR1aa0rkwjKvk1rJ8oUPGJ0CRu85JTVSsjJrGkUM=";

  types-aiobotocore-snowball =
    buildTypesAiobotocorePackage "snowball" "2.20.0"
      "sha256-jHCBu3/qlDw8VmjdDf/xxb7TttFGJhRrTdoBg14a1rc=";

  types-aiobotocore-sns =
    buildTypesAiobotocorePackage "sns" "2.20.0"
      "sha256-VVrR+9CNFOFgLtdugyHqzmQX2y2NlKvW6c4qxAYqPU8=";

  types-aiobotocore-sqs =
    buildTypesAiobotocorePackage "sqs" "2.20.0"
      "sha256-MdDbe5cPFLQ2Dx0PmEKJ145ppCo1for34M5wYrw2lV0=";

  types-aiobotocore-ssm =
    buildTypesAiobotocorePackage "ssm" "2.20.0"
      "sha256-2gaJCUiqSLUURu9pYczOFMKJ/YZM/LkSuI6Qz0GprD0=";

  types-aiobotocore-ssm-contacts =
    buildTypesAiobotocorePackage "ssm-contacts" "2.20.0"
      "sha256-WYv0ON/8aTFOlng2b4viJQk4niAjRvEK1u4qFKnXmLE=";

  types-aiobotocore-ssm-incidents =
    buildTypesAiobotocorePackage "ssm-incidents" "2.20.0"
      "sha256-HylomMcU1TUhas5j02Zr0Alyu9j03RzgX/A0gERlTos=";

  types-aiobotocore-ssm-sap =
    buildTypesAiobotocorePackage "ssm-sap" "2.20.0"
      "sha256-CRqZufbf/0QfVkAHb69YAo8Uhn+ECGn1Xv9VWreZ2RQ=";

  types-aiobotocore-sso =
    buildTypesAiobotocorePackage "sso" "2.20.0"
      "sha256-4R5N44eEQBFIhN3Ik+HmberNF0I4HKWOxy7bIcjyV+I=";

  types-aiobotocore-sso-admin =
    buildTypesAiobotocorePackage "sso-admin" "2.20.0"
      "sha256-Zb7WIjxzMsGSs5ZIh93hQVLmJHEKGZGLNMohg2O29QI=";

  types-aiobotocore-sso-oidc =
    buildTypesAiobotocorePackage "sso-oidc" "2.20.0"
      "sha256-l6rWuVpk3WoM7BX6iymFtJrzC2BwLoqepC7Y9xk4MIE=";

  types-aiobotocore-stepfunctions =
    buildTypesAiobotocorePackage "stepfunctions" "2.20.0"
      "sha256-Hlfg2aSO508eL9uYujgPYmtKAw5lifb+UJDABzJ1Aso=";

  types-aiobotocore-storagegateway =
    buildTypesAiobotocorePackage "storagegateway" "2.20.0"
      "sha256-sor2ldlP9AE0ukNWKU9bFLYoD66yJAmnqH9Zp3yVcfc=";

  types-aiobotocore-sts =
    buildTypesAiobotocorePackage "sts" "2.20.0"
      "sha256-WjroZx9ZftfHVtgJQ01jUiLSMrvogalzZBpOAI3VmdE=";

  types-aiobotocore-support =
    buildTypesAiobotocorePackage "support" "2.20.0"
      "sha256-iKoKzBCgZL7wqP9QjTLGioc+ePAbV3KQ2pGGO9Pp4bs=";

  types-aiobotocore-support-app =
    buildTypesAiobotocorePackage "support-app" "2.20.0"
      "sha256-XwYNrWeDEfddURSE1e9a6qBXYPcEPpVTWq+xG6LNlYA=";

  types-aiobotocore-swf =
    buildTypesAiobotocorePackage "swf" "2.20.0"
      "sha256-GIEQu37JnuB0jBcmX4HjAhszUqbkRZQcRIA0sQrv7s4=";

  types-aiobotocore-synthetics =
    buildTypesAiobotocorePackage "synthetics" "2.20.0"
      "sha256-N8NajAll6AH0pqxHkERCHlrDPuRCp03vybBnmTumV9U=";

  types-aiobotocore-textract =
    buildTypesAiobotocorePackage "textract" "2.20.0"
      "sha256-fkUTIt3w7peKkP+B0g3OaUJ41U+3TS0A0D1vdny6wtU=";

  types-aiobotocore-timestream-query =
    buildTypesAiobotocorePackage "timestream-query" "2.20.0"
      "sha256-PUlQOyahyqP47xsup81zBJgs2kCIIJL9cLA9mcXzqEU=";

  types-aiobotocore-timestream-write =
    buildTypesAiobotocorePackage "timestream-write" "2.20.0"
      "sha256-PUL98qOyCabCzMf12fozdioh1IJRIuGIm9zMXhKuOhw=";

  types-aiobotocore-tnb =
    buildTypesAiobotocorePackage "tnb" "2.20.0"
      "sha256-oKwf8+TniZ3fCJtEq7KDtsYWVspvW5jfs7LsD3S7VbM=";

  types-aiobotocore-transcribe =
    buildTypesAiobotocorePackage "transcribe" "2.20.0"
      "sha256-WBLpyr0c7SPDZGL42MFEDwiLyyI8A8jhY7F38l+bcPE=";

  types-aiobotocore-transfer =
    buildTypesAiobotocorePackage "transfer" "2.20.0"
      "sha256-IYw9Z5pDY+ofI4Za+mK5k3CkIQMetp68xSJUkalw1mk=";

  types-aiobotocore-translate =
    buildTypesAiobotocorePackage "translate" "2.20.0"
      "sha256-XijJhveJkiGax51dyrBMW9chhIro18JY1+inHYHK+Zc=";

  types-aiobotocore-verifiedpermissions =
    buildTypesAiobotocorePackage "verifiedpermissions" "2.20.0"
      "sha256-Gg5ynPCypN/H0pr7CMJlaZtlzMps9509XLl152F2K5E=";

  types-aiobotocore-voice-id =
    buildTypesAiobotocorePackage "voice-id" "2.20.0"
      "sha256-EQs6TC387bA4Db1D3Een/dedkDBu1RYsgA1QIAkHhDI=";

  types-aiobotocore-vpc-lattice =
    buildTypesAiobotocorePackage "vpc-lattice" "2.20.0"
      "sha256-7bfmouHUzobWvW7k3MMW5UEN3MUMMocYlY8PNjU//Mo=";

  types-aiobotocore-waf =
    buildTypesAiobotocorePackage "waf" "2.20.0"
      "sha256-YlUG+Hv32qMmDCaTVl6/vMTNP7RYbwxkdkKONE7O1EM=";

  types-aiobotocore-waf-regional =
    buildTypesAiobotocorePackage "waf-regional" "2.20.0"
      "sha256-CacWY6NFSUgxcj3n648rwAMMWeHeTmnZ0kG5d3G9dLA=";

  types-aiobotocore-wafv2 =
    buildTypesAiobotocorePackage "wafv2" "2.20.0"
      "sha256-P7JdHfav5QBDOVTEA9ctgouKubJ2/bIn5ZLTNCD+CG4=";

  types-aiobotocore-wellarchitected =
    buildTypesAiobotocorePackage "wellarchitected" "2.20.0"
      "sha256-yE389Lumciz45OiPdHDqD9bdBDrWX/sJT3Md31P9w5o=";

  types-aiobotocore-wisdom =
    buildTypesAiobotocorePackage "wisdom" "2.20.0"
      "sha256-1StnwNCrqDk8eJWnmRk0Q1KxFYwiT5i6gKziJE/fSYY=";

  types-aiobotocore-workdocs =
    buildTypesAiobotocorePackage "workdocs" "2.20.0"
      "sha256-U8LYlz6ZX7lqx0FqFOEudQ821qPKywIE57BndGFuJXA=";

  types-aiobotocore-worklink =
    buildTypesAiobotocorePackage "worklink" "2.15.1"
      "sha256-VvuxiybvGaehPqyVUYGO1bbVSQ0OYgk6LbzgoKLHF2c=";

  types-aiobotocore-workmail =
    buildTypesAiobotocorePackage "workmail" "2.20.0"
      "sha256-s05lG5dt6lIwI62Tuv+0BbRND6fPkgJ6rGYTUmM1D44=";

  types-aiobotocore-workmailmessageflow =
    buildTypesAiobotocorePackage "workmailmessageflow" "2.20.0"
      "sha256-IRDrby8CN3iamkfFqw5GT9xryZW+xuo0T8Ll+wYvTVY=";

  types-aiobotocore-workspaces =
    buildTypesAiobotocorePackage "workspaces" "2.20.0"
      "sha256-wj4YYRdj6WqnvmA7/x07lwcYIFZX4V6kWwnfFaPHEfc=";

  types-aiobotocore-workspaces-web =
    buildTypesAiobotocorePackage "workspaces-web" "2.20.0"
      "sha256-p377jsL/oUCBgRiQC0iJXr+RtFrJ3ZRTZ3pxujqchH4=";

  types-aiobotocore-xray =
    buildTypesAiobotocorePackage "xray" "2.20.0"
      "sha256-Mluhwum6BrRRX53vkxGRrdy1WrMvxrKrB86d9+OSYsI=";
}
