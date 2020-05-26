<!-- @head-content@ -->
# laplacian/generator.project-template

这个模板模块生成标准目录结构和常用脚本，用于在Laplacian项目中构建和发布到本地资源库。


*Read this in other languages*: [[English](README.md)] [[日本語](README_ja.md)]
<!-- @head-content@ -->

<!-- @toc@ -->
## Table of contents
- [如何使用](#如何使用)

- [索引](#索引)

  * [命令列表](#命令列表)

  * [源码列表](#源码列表)



<!-- @toc@ -->

<!-- @main-content@ -->
## 如何使用

要应用此template模块，请在项目定义中加入以下条目

```yaml
project:
  templates:
  - group: laplacian
    name: generator.project-template
    version: 1.0.0
```

您可以运行以下命令查看受本模块应用影响的资源列表及其内容

```console
$ ./script/generate --dry-run

diff --color -r PROJECT_HOME/.NEXT/somewhere/something.md PROJECT_HOME/somewhere/something.md
1,26c1,10
< content: OLD CONTENT
---
> content: NEW CONTENT
```

如果没有问题，请执行下面的命令来反映变化

```console
$ ./script/generate

```


## 索引


### 命令列表


- [./script/generate.sh](<./scripts/generate.sh>)

  生成本项目中每个`src/` `model/` `template/`目录下的资源。
  结果反映在`dest/` `doc/` `script/`的每个目录中。

  *生成器输入文件*

  - `src/`
    存储未被生成器处理的静态资源。
    这个目录的内容直接复制到`dest/`目录中。

  - `model/`
    存储以 *YAML* 或 *JSON* 格式编写的静态模型数据文件，用于生成。

  - `template/`
    这个目录中包含了用于生成的模板文件。
    扩展名为`.hbs`的文件将作为模板处理。所有其他文件都会被复制。

    - `template/dest` `template/doc` `template/scripts`
      这些目录中的每一个目录都包含要输出的资源的模板文件，其目录为 `dest/`doc/`scripts`。

    - `template/model` `template/template`
      这些目录存储模板文件，更新生成过程中使用的`template/`和`model/`的内容。
      如果在生成过程中更新了 `template/` `model/` 的内容，则生成过程将递归执行。
      在上述过程中发生的对 `template/` `model/` 的变化被视为中间状态，并在过程完成后丢失。
      使用 *--dry-run* 选项来检查这些中间文件。

  *生成器输出文件*

  - `dest/`
    输出作为生成过程的结果的应用程序和模块的源文件。

  - `doc/`
    输出项目文件。

  - `scripts/`
    输出开发和操作中使用的各种脚本。

  > Usage: generate.sh [OPTION]...
  >
  > -h, --help
  >
  >   显示如何使用此命令。
  >   
  > -v, --verbose
  >
  >   显示更详细的命令执行信息。
  >   
  > -d, --dry-run
  >
  >   该命令处理完毕后，生成的文件将被输出到`.NEXT`目录下。
  >   不反映到`dest/`doc/`doc/`scripts/`文件夹中。
  >   此外，`.NEXT`目录的内容与当前文件之间的差异。
  >   这个目录还包含了在生成过程中创建的任何中间文件。
  >   
  > -r, --max-recursion [VALUE]
  >
  >   当`model/` `template/`目录的内容在生成过程中被更新时，递归执行的次数上限。
  >    (Default: 10)
- [./script/publish-local.sh](<./scripts/publish-local.sh>)

  项目中的资源生成后，在`./dest`目录下的资源作为模板模块建立，并在本地资源库中注册。

  > Usage: publish-local.sh [OPTION]...
  >
  > -h, --help
  >
  >   显示如何使用此命令。
  >   
  > -v, --verbose
  >
  >   显示更详细的命令执行信息。
  >   
  > -r, --max-recursion [VALUE]
  >
  >   这个选项与[generate.sh](<./scripts/generate.sh>)中的同名选项相同。
  >    (Default: 10)
  > , --skip-generation
  >
  >   这个选项与[generate.sh](<./scripts/generate.sh>)中的同名选项相同。
  >   
### 源码列表


- [model/project.yaml](<./model/project.yaml>)
- [src/{each project.document.languages as lang}/README{case (eq lang.code 'en') '' (concat '_' lang.code)}.md.hbs](<./src/{each project.document.languages as lang}/README{case (eq lang.code 'en') '' (concat '_' lang.code)}.md.hbs>)
- [src/.editorconfig.hbs](<./src/.editorconfig.hbs>)
- [src/.gitattributes.hbs](<./src/.gitattributes.hbs>)
- [src/.gitignore.hbs](<./src/.gitignore.hbs>)
- [src/{if entities}model-schema.json.hbs](<./src/{if entities}model-schema.json.hbs>)
- [src/model/project/document/languages.yaml](<./src/model/project/document/languages.yaml>)
- [src/model/project/document/sections/{if (or project.template project.model)}/usage.hbs.yaml](<./src/model/project/document/sections/{if (or project.template project.model)}/usage.hbs.yaml>)
- [src/model/project/document/sections/index/{if project.scripts}/script-list.hbs.yaml](<./src/model/project/document/sections/index/{if project.scripts}/script-list.hbs.yaml>)
- [src/model/project/document/sections/index/{if project.sources}/source-code-list.hbs.yaml](<./src/model/project/document/sections/index/{if project.sources}/source-code-list.hbs.yaml>)
- [src/model/project/document/sections.yaml](<./src/model/project/document/sections.yaml>)
- [src/model/project/scripts/{each project.subprojects as subproject}/generate-{hyphen subproject.name}.hbs.yaml](<./src/model/project/scripts/{each project.subprojects as subproject}/generate-{hyphen subproject.name}.hbs.yaml>)
- [src/model/project/scripts/{each project.subprojects as subproject}/publsh-local-{hyphen subproject.name}.hbs.yaml](<./src/model/project/scripts/{each project.subprojects as subproject}/publsh-local-{hyphen subproject.name}.hbs.yaml>)
- [src/model/project/scripts/generate.hbs.yaml](<./src/model/project/scripts/generate.hbs.yaml>)
- [src/model/project/scripts/{if project.subprojects}/do-each-subproject.hbs.yaml](<./src/model/project/scripts/{if project.subprojects}/do-each-subproject.hbs.yaml>)
- [src/model/project/scripts/{if project.subprojects}/generate-all.hbs.yaml](<./src/model/project/scripts/{if project.subprojects}/generate-all.hbs.yaml>)
- [src/model/project/scripts/{if project.subprojects}/git-each-subproject.hbs.hbs.yaml](<./src/model/project/scripts/{if project.subprojects}/git-each-subproject.hbs.hbs.yaml>)
- [src/model/project/scripts/publish-local.hbs.yaml](<./src/model/project/scripts/publish-local.hbs.yaml>)
- [src/scripts/.configure-vscode/vscode-settings.json.hbs](<./src/scripts/.configure-vscode/vscode-settings.json.hbs>)
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


<!-- @main-content@ -->