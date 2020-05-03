<!-- @head-content@ -->
# laplacian/project.base-template

このテンプレートモジュールは、Laplacianプロジェクトにおける標準的なディレクトリ構成と、
ビルドおよびローカルリポジトリへの公開を行う共通的なスクリプトを生成します。


*Read this in other languages*: [[English](README.md)] [[简体中文](README_zh.md)]
<!-- @head-content@ -->

<!-- @toc@ -->
## Table of contents
1. [使用方法](#使用方法)
1. [インデックス](#インデックス)


<!-- @toc@ -->

<!-- @main-content@ -->
## 使用方法

この templateモジュールを適用するには、プロジェクト定義に以下のエントリを追加してください。
```yaml
project:
  templates:
  - group: laplacian
    name: project.base-template
    version: 1.0.0
```

下記のコマンドを実行すると、このモジュールの適用によって影響を受ける資源の一覧とその内容を確認できます。

```console
$ ./script/generate --dry-run

diff --color -r PROJECT_HOME/.NEXT/somewhere/something.md PROJECT_HOME/somewhere/something.md
1,26c1,10
< content: OLD CONTENT
---
> content: NEW CONTENT
```

内容に問題が無ければ、下記コマンドを実行して変更を反映してください。

```console
$ ./script/generate --dry-run

```


## インデックス


### ソースコード一覧


- [model/project.yaml](<./model/project.yaml>)
- [src/.editorconfig.hbs](<./src/.editorconfig.hbs>)
- [src/.gitattributes.hbs](<./src/.gitattributes.hbs>)
- [src/.gitignore.hbs](<./src/.gitignore.hbs>)
- [src/scripts/{each project.subprojects as subproject}{hyphen subproject.group}-{hyphen subproject.name}/publish-local.sh.hbs](<./src/scripts/{each project.subprojects as subproject}{hyphen subproject.group}-{hyphen subproject.name}/publish-local.sh.hbs>)
- [src/scripts/{each project.subprojects as subproject}{hyphen subproject.group}-{hyphen subproject.name}/update-project.sh.hbs](<./src/scripts/{each project.subprojects as subproject}{hyphen subproject.group}-{hyphen subproject.name}/update-project.sh.hbs>)
- [src/scripts/generate.sh.hbs](<./src/scripts/generate.sh.hbs>)
- [src/scripts/{if project.subprojects}git-status-subprojects.sh.hbs](<./src/scripts/{if project.subprojects}git-status-subprojects.sh.hbs>)
- [src/scripts/{if project.subprojects}update-subprojects.sh.hbs](<./src/scripts/{if project.subprojects}update-subprojects.sh.hbs>)
- [src/scripts/laplacian-generate.sh](<./src/scripts/laplacian-generate.sh>)
- [src/scripts/laplacian/gradlew](<./src/scripts/laplacian/gradlew>)
- [src/scripts/laplacian/gradle/wrapper/gradle-wrapper.jar](<./src/scripts/laplacian/gradle/wrapper/gradle-wrapper.jar>)
- [src/scripts/laplacian/gradle/wrapper/gradle-wrapper.properties](<./src/scripts/laplacian/gradle/wrapper/gradle-wrapper.properties>)
- [src/scripts/{unless (eq project.role 'generator')}publish-local.sh.hbs](<./src/scripts/{unless (eq project.role 'generator')}publish-local.sh.hbs>)
- [src/scripts/update-project.sh](<./src/scripts/update-project.sh>)


<!-- @main-content@ -->