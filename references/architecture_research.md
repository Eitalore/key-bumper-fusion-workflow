# Pesquisa de arquitetura — OpenSCAD, GitHub Actions e Fusion 360

## Decisões confirmadas

1. A Autodesk disponibiliza a Fusion API para scripts, add-ins e aplicações que automatizam tarefas e integram sistemas externos: https://aps.autodesk.com/developer/overview/autodesk-fusion-api
2. A documentação oficial do Fusion separa User's Manual, Reference Manual e Code Samples: https://help.autodesk.com/view/fusion360/ENU/?guid=GUID-A92A4B10-3781-4925-94C6-47DA85A4F65A
3. A Autodesk mantém exemplos de GitHub para Fusion, incluindo Parameter I/O, que importa/atualiza parâmetros a partir de CSV: https://github.com/AutodeskFusion360/ParameterIO_Python
4. A orientação oficial da Autodesk para STL recomenda inserir a malha usando Insert Mesh; STL é uma malha triangular e pode exigir remesh/redução para bom desempenho: https://www.autodesk.com/products/fusion-360/blog/mastering-stl-meshes-autodesk-fusion/
5. O repositório pkoehlers/openscad-build-action usa OpenSCAD CLI em GitHub Actions para gerar artefatos a partir de arquivos SCAD, incluindo STL e parâmetros Customizer: https://github.com/pkoehlers/openscad-build-action
6. A biblioteca BOSL2 é compatível com OpenSCAD 2021.01+ e fornece módulos de formas arredondadas, transformações, máscaras e componentes mecânicos: https://github.com/BelfrySCAD/BOSL2/

## Arquitetura proposta

- GitHub armazena fonte SCAD, parâmetros CSV/JSON, documentação, script do Fusion e workflow.
- GitHub Actions valida sintaxe/estrutura, executa OpenSCAD CLI para gerar STL e publica os artefatos do commit.
- Fusion 360 recebe um add-in Python local. O add-in lê um CSV/JSON de parâmetros ou abre um STL gerado e o insere como malha; a conversão e inspeção continuam locais no Fusion, pois a API local exige o Fusion em execução.
- A integração não deve prometer execução do Fusion 360 dentro de GitHub Actions; o workflow gera artefatos e o add-in local sincroniza/importa.

## Limites

- As dimensões da chave continuam sendo dados medidos pelo usuário; nenhum agente ou workflow deve inventá-las.
- STL não preserva a parametrização do OpenSCAD.
- Para integração bidirecional com Autodesk cloud seriam necessários Autodesk Platform Services e credenciais próprias; não serão incluídos por padrão.
- O GitHub não deve receber segredos no código; publicar é bloqueado até o conector GitHub estar habilitado e autenticado.
