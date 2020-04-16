<!-- @head-content@ -->
# laplacian/project-base.template

This template generates scripts and other files needed for all Laplacian module projects.

<!-- @head-content@ -->

<!-- @toc -->
## Table of contents
1. [Usage](#usage)


1. [Source list](#source-list)



<!-- @toc -->

<!-- @main-content -->
## Usage

Add the following entry to your project definition.
```yaml
project:
  templates:
  - group: laplacian
    name: project-base.template
    version: 1.0.0
```




## Source list


[src/README.md.hbs](<./src/README.md.hbs>)

[src/scripts/publish-local.sh.hbs](<./src/scripts/publish-local.sh.hbs>)

[src/scripts/update-project.sh](<./src/scripts/update-project.sh>)

[src/scripts/{each project.subprojects as subproject}{hyphen subproject.group}-{hyphen subproject.name}/update-project.sh.hbs](<./src/scripts/{each project.subprojects as subproject}{hyphen subproject.group}-{hyphen subproject.name}/update-project.sh.hbs>)

[src/scripts/{each project.subprojects as subproject}{hyphen subproject.group}-{hyphen subproject.name}/publish-local.sh.hbs](<./src/scripts/{each project.subprojects as subproject}{hyphen subproject.group}-{hyphen subproject.name}/publish-local.sh.hbs>)

[src/scripts/{if project.subprojects}update-subprojects.sh.hbs](<./src/scripts/{if project.subprojects}update-subprojects.sh.hbs>)

[src/scripts/{if (or project.templates project.template_files)}generate.sh.hbs](<./src/scripts/{if (or project.templates project.template_files)}generate.sh.hbs>)

[src/scripts/laplacian-generate.sh](<./src/scripts/laplacian-generate.sh>)

[src/scripts/{if project.subprojects}git-status-subprojects.sh.hbs](<./src/scripts/{if project.subprojects}git-status-subprojects.sh.hbs>)

[src/.gitignore.hbs](<./src/.gitignore.hbs>)

[src/.gitattributes.hbs](<./src/.gitattributes.hbs>)

[src/.editorconfig.hbs](<./src/.editorconfig.hbs>)

[.editorconfig](<./.editorconfig>)

[.gitignore](<./.gitignore>)

[README.md](<./README.md>)

[.gitattributes](<./.gitattributes>)

[model/project.yaml](<./model/project.yaml>)

[model/project/sources.yaml](<./model/project/sources.yaml>)





<!-- @main-content -->