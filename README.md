# Key Bumper Fusion Workflow

Repositório para desenvolver capas bumper paramétricas de chaves automotivas em TPU, usando OpenSCAD/BOSL2, geração automatizada de STL e inspeção local no Autodesk Fusion 360.

> As dimensões das chaves incluídas são hipóteses de protótipo até serem substituídas por medições físicas. O repositório não deve ser usado para assumir dimensões oficiais da montadora.

## O que este repositório contém

| Pasta | Conteúdo |
|---|---|
| `models/openscad/` | Fontes SCAD editáveis para Geely EX2, BYD Dolphin, BYD Yuan Pro e BYD Seal |
| `models/parameters/` | CSV de medidas e parâmetros iniciais por modelo |
| `scripts/` | Validação determinística do projeto |
| `fusion_addin/` | Add-in Python local para inserir STL e parâmetros no Fusion 360 |
| `.github/workflows/` | Workflow para validar e gerar STL como artefato |
| `docs/` | Guia de medição, OpenSCAD, TPU, Fusion 360 e primeira amostra |
| `references/` | Decisões de arquitetura e fontes técnicas |

## Fluxo recomendado

1. Meça a chave física com paquímetro.
2. Atualize o CSV correspondente e os parâmetros no começo do SCAD.
3. Execute `python scripts/validate_project.py`.
4. Abra o SCAD no OpenSCAD ou no OpenSCAD Playground.
5. Gere o STL localmente ou aguarde o workflow do GitHub.
6. Insira o STL no Fusion 360 usando o add-in ou `Insert Mesh`.
7. Compare com um corpo de referência da chave e verifique interferências.
8. Imprima a amostra em TPU e registre os ajustes.

## BOSL2

A variante `geely_ex2_bumper_bosl2_v01.scad` requer [BOSL2](https://github.com/BelfrySCAD/BOSL2/). No macOS, instale a pasta em `~/Documents/OpenSCAD/libraries/BOSL2/` e reinicie o OpenSCAD. O workflow baixa a dependência em uma pasta temporária durante a geração.

## Fusion 360

O Fusion 360 é integrado localmente por um add-in Python. O GitHub Actions não executa o Fusion com interface gráfica; ele apenas valida e gera STL. O add-in permite selecionar um STL gerado e inseri-lo como malha no documento ativo, além de ler o CSV de parâmetros para criar User Parameters auxiliares.

A instalação está descrita em `fusion_addin/README.md`. O add-in exige o Fusion 360 instalado e um documento de design aberto.

## GitHub Actions

O workflow `build-models.yml` roda em pushes e pull requests. Ele:

- instala OpenSCAD CLI;
- baixa BOSL2 para a variante que depende dela;
- valida o repositório;
- gera STL dos modelos;
- publica os STL como artefatos da execução.

O workflow não usa tokens do Fusion e não publica automaticamente em um hub Autodesk.

## Licença

O código original deste repositório é distribuído sob MIT. A BOSL2 é uma dependência externa e mantém a licença própria; não a copie para este repositório sem necessidade.

## Referências

[Autodesk Fusion API](https://aps.autodesk.com/developer/overview/autodesk-fusion-api) · [Fusion API documentation](https://help.autodesk.com/view/fusion360/ENU/?guid=GUID-A92A4B10-3781-4925-94C6-47DA85A4F65A) · [Autodesk ParameterIO sample](https://github.com/AutodeskFusion360/ParameterIO_Python) · [Autodesk STL mesh guide](https://www.autodesk.com/products/fusion-360/blog/mastering-stl-meshes-autodesk-fusion/) · [BOSL2](https://github.com/BelfrySCAD/BOSL2/)
