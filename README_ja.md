<!-- @head-content@ -->
# laplacian/generator.project-template

このテンプレートモジュールは、Laplacianプロジェクトにおける標準的なディレクトリ構成と、
ビルドおよびローカルリポジトリへの公開を行う共通的なスクリプトを生成します。


*Read this in other languages*: [[English](README.md)] [[简体中文](README_zh.md)]
<!-- @head-content@ -->

<!-- @toc@ -->
## Table of contents
- [使用方法](#使用方法)

- [インデックス](#インデックス)

  * [スクリプト一覧](#スクリプト一覧)

  * [ソースコード一覧](#ソースコード一覧)



<!-- @toc@ -->

<!-- @main-content@ -->
## 使用方法

この templateモジュールを適用するには、プロジェクト定義に以下のエントリを追加してください。
```yaml
project:
  templates:
  - group: laplacian
    name: generator.project-template
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
$ ./script/generate

```


## インデックス


### スクリプト一覧


- [./script/generate.sh](<./scripts/generate.sh>)

  このプロジェクト内の資源を自動生成します。
  `src/` `model/` `template/` の各ディレクトリに格納された資源をもとに自動生成を行い、その結果を`dest/` `doc/` `script/` の各ディレクトリに反映します。

  *自動生成入力ファイル*

  - `src/`
    自動生成の対象とならない静的な資源を格納します。
    このディレクトリの内容は `dest/` 配下にそのままコピーされます。

  - `model/`
    自動生成で使用されるYAMLもしくはJSON形式で記述された静的なモデルデータを格納します。

  - `template/`
    自動生成で使用されるテンプレートファイルを格納します。ファイル拡張子に `.hbs` を含むファイルがテンプレートして扱われます。
    それ以外のファイルはそのままコピーされます。

    - `template/dest` `template/doc` `template/scripts`
      これらのディレクトリはそれぞれ、`dest/` `doc/` `scripts`の各ディレクトリに出力される資源のテンプレートを格納します。

    - `template/model` `template/template`
      自動生成で使用される`template/` `model/`の内容を更新するためのテンプレートを格納します。
      自動生成の結果、`template/` `model/` の内容が更新された場合は、自動生成処理を再帰的に実行します。
      なお、上記処理中に発生した`template/` `model/`への変更は、中間状態として扱われるため、処理完了後は失われます。
      これらの中間ファイルを確認するためには *--dry-run* オプションを使用してください。

  *自動生成結果ファイル*

  - `dest/`
    自動生成の結果作成されるアプリケーションやモジュールのソースファイル等を出力します。

  - `doc/`
    プロジェクトのドキュメントを出力します。

  - `scripts/`
    開発・運用で使用する各種スクリプトを出力します。

  > Usage: generate.sh [OPTION]...
  >
  > -h, --help
  >
  >   このコマンドの使用方法を表示します。
  >   
  > -v, --verbose
  >
  >   より詳細なコマンドの実行情報を表示します。
  >   
  > -d, --dry-run
  >
  >   自動生成処理を実行後、生成されたファイルを`dest/` `doc/` `scripts/`の各フォルダに反映せずに、`.NEXT`ディレクトリに出力します。
  >   また、`.NEXT`ディレクトリの内容と現在のファイルの差異を出力します。
  >   このディレクトリには自動生成中に作成された中間ファイルも含まれます。
  >   
  > -r, --max-recursion [VALUE]
  >
  >   自動生成処理中に`model/` `template/`ディレクトリの内容が更新された場合に、
  >   再帰的に自動生成処理を実行する回数の上限。
  >    (Default: 10)
  > , --local-module-repository [VALUE]
  >
  >   ローカルでビルドされたモジュールを格納するリポジトリのパス。
  >   ここに存在するモジュールが最優先で参照される。
  >   
- [./script/publish-local.sh](<./scripts/publish-local.sh>)

  プロジェクト内の資源を自動生成した後、ディレクトリにある資源をテンプレートモジュールとしてビルドし、
  ローカルリポジトリに登録します。

  > Usage: publish-local.sh [OPTION]...
  >
  > -h, --help
  >
  >   このコマンドの使用方法を表示します。
  >   
  > -v, --verbose
  >
  >   より詳細なコマンドの実行情報を表示します。
  >   
  > -r, --max-recursion [VALUE]
  >
  >   [generate.sh](<./scripts/generate.sh>)の同名のオプションと同じものです。
  >    (Default: 10)
  > , --skip-generation
  >
  >   自動生成処理を行わずに、ビルドおよびローカルリポジトリへの登録を行います。
  >   
  > , --local-module-repository [VALUE]
  >
  >   ビルドしたモジュールを格納するローカルリポジトリのパス。
  >   指定したパスにリポジトリが存在しない場合は、自動的に作成されます。
  >   
### ソースコード一覧


- [model/project.yaml](<./model/project.yaml>)
- [src/{each project.document.languages as lang}/README{case (eq lang.code 'en') '' (concat '_' lang.code)}.md.hbs](<./src/{each project.document.languages as lang}/README{case (eq lang.code 'en') '' (concat '_' lang.code)}.md.hbs>)
- [src/.editorconfig.hbs](<./src/.editorconfig.hbs>)
- [src/.gitattributes.hbs](<./src/.gitattributes.hbs>)
- [src/.gitignore.hbs](<./src/.gitignore.hbs>)
- [src/{if entities}{each (list-of 'partial' 'full') as mode}/model-schema-{mode}.json.hbs](<./src/{if entities}{each (list-of 'partial' 'full') as mode}/model-schema-{mode}.json.hbs>)
- [src/model/project/document/languages.hbs.yaml](<./src/model/project/document/languages.hbs.yaml>)
- [src/model/project/document/sections.hbs.yaml](<./src/model/project/document/sections.hbs.yaml>)
- [src/model/project/document/sections/{if (or project.template project.model)}/usage.hbs.yaml](<./src/model/project/document/sections/{if (or project.template project.model)}/usage.hbs.yaml>)
- [src/model/project/document/sections/index/{if project.scripts}/script-list.yaml.hbs](<./src/model/project/document/sections/index/{if project.scripts}/script-list.yaml.hbs>)
- [src/model/project/document/sections/index/{if project.sources}/source-code-list.hbs.yaml](<./src/model/project/document/sections/index/{if project.sources}/source-code-list.hbs.yaml>)
- [src/model/project/scripts/{each project.subprojects as subproject}/generate-{hyphen subproject.name}.hbs.yaml](<./src/model/project/scripts/{each project.subprojects as subproject}/generate-{hyphen subproject.name}.hbs.yaml>)
- [src/model/project/scripts/{each project.subprojects as subproject}/publsh-local-{hyphen subproject.name}.hbs.yaml](<./src/model/project/scripts/{each project.subprojects as subproject}/publsh-local-{hyphen subproject.name}.hbs.yaml>)
- [src/model/project/scripts/generate.hbs.yaml](<./src/model/project/scripts/generate.hbs.yaml>)
- [src/model/project/scripts/{if project.subprojects}/do-each-subproject.hbs.yaml](<./src/model/project/scripts/{if project.subprojects}/do-each-subproject.hbs.yaml>)
- [src/model/project/scripts/{if project.subprojects}/generate-all.hbs.yaml](<./src/model/project/scripts/{if project.subprojects}/generate-all.hbs.yaml>)
- [src/model/project/scripts/{if project.subprojects}/git-each-subproject.hbs.hbs.yaml](<./src/model/project/scripts/{if project.subprojects}/git-each-subproject.hbs.hbs.yaml>)
- [src/model/project/scripts/publish-local.hbs.yaml](<./src/model/project/scripts/publish-local.hbs.yaml>)
- [src/scripts/{each project.scripts as script}/{hyphen script.name}.hbs.sh](<./src/scripts/{each project.scripts as script}/{hyphen script.name}.hbs.sh>)
- [src/scripts/{each project.subprojects as subproject}/.generate-{hyphen subproject.name}/main.hbs.sh](<./src/scripts/{each project.subprojects as subproject}/.generate-{hyphen subproject.name}/main.hbs.sh>)
- [src/scripts/{each project.subprojects as subproject}/.publish-local-{hyphen subproject.name}/main.hbs.sh](<./src/scripts/{each project.subprojects as subproject}/.publish-local-{hyphen subproject.name}/main.hbs.sh>)
- [src/scripts/.generate/main.hbs.sh](<./src/scripts/.generate/main.hbs.sh>)
- [src/scripts/{if project.subprojects}/.do-each-subproject/main.hbs.sh](<./src/scripts/{if project.subprojects}/.do-each-subproject/main.hbs.sh>)
- [src/scripts/{if project.subprojects}/.generate-all/main.hbs.sh](<./src/scripts/{if project.subprojects}/.generate-all/main.hbs.sh>)
- [src/scripts/{if project.subprojects}/.git-each-subproject/main.hbs.sh](<./src/scripts/{if project.subprojects}/.git-each-subproject/main.hbs.sh>)
- [src/scripts/{if project.subprojects}update-subprojects.sh.hbs](<./src/scripts/{if project.subprojects}update-subprojects.sh.hbs>)
- [src/scripts/laplacian-generate.sh](<./src/scripts/laplacian-generate.sh>)
- [src/scripts/laplacian/gradlew](<./src/scripts/laplacian/gradlew>)
- [src/scripts/laplacian/gradle/wrapper/gradle-wrapper.jar](<./src/scripts/laplacian/gradle/wrapper/gradle-wrapper.jar>)
- [src/scripts/laplacian/gradle/wrapper/gradle-wrapper.properties](<./src/scripts/laplacian/gradle/wrapper/gradle-wrapper.properties>)
- [src/scripts/.publish-local/{if (or project.template project.model)}/publish.hbs.sh](<./src/scripts/.publish-local/{if (or project.template project.model)}/publish.hbs.sh>)
- [src/scripts/.publish-local/main.hbs.sh](<./src/scripts/.publish-local/main.hbs.sh>)
- [src/.vscode/settings.json.hbs](<./src/.vscode/settings.json.hbs>)


<!-- @main-content@ -->