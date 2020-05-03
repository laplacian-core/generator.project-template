<!-- @head-content@ -->
# laplacian/project.base-template

这个模板模块生成标准目录结构和常用脚本，用于在Laplacian项目中构建和发布到本地资源库。


*Read this in other languages*: [[English](README.md)] [[日本語](README_ja.md)]
<!-- @head-content@ -->

<!-- @toc@ -->
## Table of contents
1. [如何使用](#如何使用)
1. [索引](#索引)


<!-- @toc@ -->

<!-- @main-content@ -->
## 如何使用

要应用此template模块，请在项目定义中加入以下条目

```yaml
project:
  templates:
  - group: laplacian
    name: project.base-template
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
$ ./script/generate --dry-run

```


## 索引


### 源码列表


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