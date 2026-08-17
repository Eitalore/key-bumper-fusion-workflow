# Auditoria de qualidade e teste de ponta a ponta

## Resultado executivo

O pacote está **apto para publicação como versão de protótipo controlado**, com uma ressalva explícita: o add-in não foi executado dentro do Fusion 360 neste ambiente, pois o Fusion é um aplicativo desktop e sua API local não está disponível no sandbox. O caminho de CSV do add-in foi testado com stubs, o manifesto XML foi validado e a integração real precisa ser confirmada no Mac com o Fusion aberto.

## Matriz de testes

| Área | Teste | Resultado |
|---|---|---|
| Estrutura | Arquivos obrigatórios, diretórios e documentação | PASS |
| Parâmetros | 5 SCAD, 4 CSV, variáveis essenciais e delimitadores | PASS |
| Segurança | Varredura de padrões de tokens/chaves privadas | PASS |
| OpenSCAD | Geração real dos cinco STL com OpenSCAD 2021.01 | PASS |
| Qualidade STL | Bounding box, triângulos, dimensões e malha não vazia | PASS com aviso BOSL2 |
| Add-in Fusion | Compilação Python e smoke test do carregamento CSV | PASS |
| Manifesto Fusion | XML do bundle e caminho do módulo | PASS |
| Workflow | YAML, jobs `validate`/`build`, artefatos e auditoria STL | PASS estrutural |
| GitHub Actions real | Execução em runner remoto | NÃO EXECUTADO neste ambiente |
| Fusion 360 real | Inserção de STL via API local | NÃO EXECUTADO neste ambiente |
| Impressão TPU | Encaixe, retenção, lâmina e desgaste | NÃO EXECUTADO; requer impressora/chave |

## Desempenho de geração

Os tempos foram medidos no sandbox com OpenSCAD 2021.01, sem representar o desempenho do Mac do usuário.

| Modelo | Tempo | STL |
|---|---:|---:|
| Geely EX2 bumper | 2,308 s | 205.676 bytes |
| Geely EX2 BOSL2 | 2,323 s | 215.166 bytes |
| BYD Dolphin | 2,150 s | 205.644 bytes |
| BYD Yuan Pro | 1,944 s | 157.641 bytes |
| BYD Seal | 2,033 s | 158.000 bytes |

O tempo total da geração sequencial ficou em aproximadamente 10,8 segundos neste ambiente. A variante BOSL2 não apresentou custo relevante de tempo em relação à versão autocontida nesta medição.

## Qualidade geométrica

Os cinco STL possuem bounding boxes coerentes com o envelope nominal dos modelos, dimensões superiores a 1 mm e inferiores a 200 mm, e não estão vazios. A versão BOSL2 produz seis triângulos colineares de área zero, equivalentes a aproximadamente 0,46% dos 1.304 triângulos. Eles estão no plano superior do ressalto e não alteram o envelope ou o volume útil; o auditor os registra como aviso e falharia acima de 1%.

Antes da impressão final, abrir o STL no Fusion 360 ou no slicer e observar a região superior do ressalto. Se o slicer reportar problemas, usar a versão sem BOSL2 ou reduzir o arredondamento do módulo de retenção.

## Correções aplicadas durante a auditoria

A auditoria encontrou e corrigiu três problemas reais na variante BOSL2:

1. A string `edges="ALL"` foi substituída por um eixo de arredondamento compatível com o slot XZ.
2. O parâmetro `BACK` foi renomeado para `BACK_THICK` para evitar colisão com a constante `BACK` da BOSL2.
3. O arredondamento e a sobreposição do ressalto foram limitados para evitar falhas de renderização e reduzir artefatos de triangulação.

## Segurança e publicação

Não foram encontrados padrões de tokens GitHub, chaves AWS ou chaves privadas no conteúdo do repositório. O workflow usa somente checkout, instalação pública do OpenSCAD, clone público da BOSL2 e upload de artefatos. Nenhum segredo Fusion ou token GitHub é armazenado no código.

## Teste local equivalente ao workflow

O equivalente local executado foi:

```text
validar SCAD/CSV
→ instalar OpenSCAD CLI
→ clonar BOSL2 em vendor/
→ gerar 5 STL
→ auditar bounding boxes e triângulos
→ compilar Python do add-in
→ testar CSV com stub Fusion
→ validar PackageContents.xml
```

## Decisão

O projeto pode ser publicado como **v0.1.0-prototype**. A publicação não deve ser descrita como validação final de fabricação. O próximo teste obrigatório após a publicação é instalar o bundle no Fusion 360 do Mac, importar um STL, carregar o CSV correspondente e comparar a malha com um corpo `CHAVE_REFERENCIA` baseado na medição física.

## Referências externas

[1]: https://aps.autodesk.com/developer/overview/autodesk-fusion-api "Autodesk Fusion API"

[2]: https://help.autodesk.com/view/fusion360/ENU/?guid=GUID-A92A4B10-3781-4925-94C6-47DA85A4F65A "Welcome to the Fusion API"

[3]: https://www.autodesk.com/products/fusion-360/blog/mastering-stl-meshes-autodesk-fusion/ "Beginner’s Guide to Mastering STL Meshes in Autodesk Fusion"

[4]: https://github.com/BelfrySCAD/BOSL2/ "BOSL2"

[5]: https://github.com/pkoehlers/openscad-build-action "OpenSCAD Build Action"
