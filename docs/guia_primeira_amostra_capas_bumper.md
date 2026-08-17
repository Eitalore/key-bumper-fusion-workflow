# Guia didático para a primeira amostra das capas bumper

## Downloads e anexos de código

Os códigos OpenSCAD usados neste procedimento estão anexados na mesma pasta deste documento:

| Modelo | Código OpenSCAD |
|---|---|
| Geely EX2 | [geely_ex2_bumper_canivete_v02.scad](geely_ex2_bumper_canivete_v02.scad) |
| Geely EX2 — versão BOSL2 | [geely_ex2_bumper_bosl2_v01.scad](geely_ex2_bumper_bosl2_v01.scad) |
| BYD Dolphin | [byd_dolphin_bumper_canivete_v02.scad](byd_dolphin_bumper_canivete_v02.scad) |
| BYD Yuan Pro | [byd_yuan_pro_bumper_v01.scad](byd_yuan_pro_bumper_v01.scad) |
| BYD Seal | [byd_seal_bumper_v01.scad](byd_seal_bumper_v01.scad) |

Para os arquivos com slot canivete, há também o [README de ajuste do slot](README_codigo_canivete.md). Para a versão BOSL2, consulte o [README de instalação e uso da BOSL2](README_BOSL2.md).


## Uso opcional da biblioteca BOSL2

A versão `geely_ex2_bumper_bosl2_v01.scad` utiliza a biblioteca [BOSL2](https://github.com/BelfrySCAD/BOSL2/), que fornece módulos para cubos arredondados, máscaras, transformações e geometrias mecânicas. O arquivo começa com:

```scad
include <BOSL2/std.scad>;
```

No macOS, instale a pasta `BOSL2` em:

```text
~/Documents/OpenSCAD/libraries/BOSL2/
```

Depois reinicie o OpenSCAD. Se o programa não encontrar a biblioteca, use **Help > Library Info** para confirmar o caminho da biblioteca do usuário. No editor online, a biblioteca precisa estar disponível no ambiente; caso contrário, use a versão sem BOSL2 ou carregue a biblioteca conforme o suporte oferecido pela plataforma.

A versão BOSL2 mantém as mesmas variáveis principais do bumper original, incluindo `KEY_L`, `KEY_W`, `KEY_T`, `KEY_R`, `CLR_*`, `BLADE_SLOT_*` e `RING_NOTCH_*`. Ela acrescenta uma orelha integrada opcional para chaveiro:

```scad
KEYRING_EAR_ENABLE = false;
KEYRING_EAR_LENGTH = 14.0;
KEYRING_EAR_WIDTH = 10.0;
KEYRING_EAR_THICKNESS = 3.0;
KEYRING_HOLE_DIAMETER = 4.5;
KEYRING_EAR_R = 2.5;
```

Se a chave física do Geely EX2 não tiver furo próprio para argola, altere `KEYRING_EAR_ENABLE = true` e confirme a posição da orelha no protótipo. Não ative essa opção sem verificar se o chaveiro real passa pelo furo.

## Modelos abrangidos

Este procedimento cobre os quatro modelos discutidos: **Geely EX2**, **BYD Dolphin**, **BYD Yuan Pro** e **BYD Seal**. A lógica é a mesma para todos, mas os arquivos e os níveis de confirmação documental são diferentes.

| Modelo | Arquivo-base atual | Slot canivete |
|---|---|---|
| Geely EX2 | [geely_ex2_bumper_canivete_v02.scad](geely_ex2_bumper_canivete_v02.scad) | Parametrizado por `BLADE_SLOT_*` |
| BYD Dolphin | [byd_dolphin_bumper_canivete_v02.scad](byd_dolphin_bumper_canivete_v02.scad) | Parametrizado por `BLADE_SLOT_*` |
| BYD Yuan Pro | [byd_yuan_pro_bumper_v01.scad](byd_yuan_pro_bumper_v01.scad) | Slot genérico por `MECH_SLOT_*`; confirmar chave antes de ampliar |
| BYD Seal | [byd_seal_bumper_v01.scad](byd_seal_bumper_v01.scad) | Slot genérico por `MECH_SLOT_*`; confirmar chave antes de ampliar |

As dimensões iniciais dos arquivos são hipóteses de projeto. A BYD confirmou funções da smart key do Dolphin e do Seal nos manuais, mas não publicou cotas da carcaça. Para o Yuan Pro, a fonte oficial brasileira confirma NFC/smartphone, mas não descreve a chave física. Portanto, a **medição física é a etapa mais importante**.

> A primeira amostra não deve ser tratada como peça final. Ela serve para validar encaixe, retenção, posição do slot lateral, acesso aos botões e possibilidade de abrir a lâmina.

## Variáveis que devem ser atualizadas após a medição física

Os arquivos OpenSCAD foram construídos para receber os dados reais da chave. **Não é necessário remodelar a peça inteira**: após medir a chave, altere os parâmetros abaixo no início do arquivo correspondente, salve uma cópia com o sufixo `_amostra01` e só então exporte o STL.

### Dimensões do corpo da chave

| Variável | O que representa | Como atualizar |
|---|---|---|
| `KEY_L` | Comprimento máximo do corpo no eixo X | Medir da extremidade da argola até o topo da chave, sem incluir metal externo |
| `KEY_W` | Largura máxima no eixo Y | Medir o maior ponto transversal do corpo |
| `KEY_T` | Espessura máxima no eixo Z | Medir incluindo ressaltos, botões e tampa traseira |
| `KEY_R` | Raio dos cantos em planta | Medir ou aproximar a partir da silhueta real |

### Folgas e estrutura do bumper

| Variável | O que representa | Quando alterar |
|---|---|---|
| `CLR_X` | Folga interna longitudinal | Aumentar se a chave não entrar; reduzir se houver movimento excessivo |
| `CLR_Y` | Folga interna por lado na largura | Ajustar em passos de 0,10–0,20 mm após o primeiro teste |
| `CLR_Z` | Folga interna sobre a espessura | Não iniciar em 0,00 mm; usar aproximadamente 0,30–0,40 mm como ponto de partida |
| `BACK` | Espessura da base traseira | Aumentar se a traseira precisar de mais proteção ou rigidez |
| `SIDE_WALL` | Espessura das paredes laterais | Aumentar se a lateral ficar fraca; reduzir somente após validar a resistência |
| `FACE_CLEARANCE` | Distância entre o topo da parede e a face dos botões | Aumentar se a parede encostar nos botões |
| `LIP_IN` | Quanto o ressalto interno avança para dentro | Reduzir se a inserção ficar difícil; aumentar se a capa escapar |
| `LIP_H` | Altura do ressalto interno | Ajustar para melhorar retenção sem bloquear a chave mecânica |

### Abertura da argola ou orelha integrada

| Variável | O que representa | Como decidir |
|---|---|---|
| `RING_NOTCH_L` | Comprimento da abertura da argola no eixo X | Usar somente se a chave possuir uma abertura ou passador compatível |
| `RING_NOTCH_W` | Largura da abertura da argola no eixo Y | Medir a largura real da cinta/argola e acrescentar folga |

Se a chave não possuir furo ou passador para argola, **não force o uso de `RING_NOTCH_*`**. Nesse caso, o bumper deverá receber uma orelha integrada própria, com comprimento, largura e diâmetro de furo definidos separadamente. Essa alteração é especialmente importante para o Geely EX2 caso a chave física realmente não tenha furo para chaveiro.

### Slot da lâmina canivete — Geely EX2 e BYD Dolphin

Nos arquivos `geely_ex2_bumper_canivete_v02.scad` e `byd_dolphin_bumper_canivete_v02.scad`, use as variáveis abaixo:

| Variável | O que representa | Como medir |
|---|---|---|
| `BLADE_SLOT_ENABLE` | Liga ou desliga o slot | Usar `true` se houver lâmina canivete; `false` se não houver |
| `BLADE_SLOT_SIDE` | Parede onde está o mecanismo | `1` para Y positivo; `-1` para Y negativo |
| `BLADE_SLOT_X` | Centro do slot no comprimento | Medir a posição da dobradiça ou do botão a partir da extremidade X=0 |
| `BLADE_SLOT_W` | Comprimento da janela no eixo X | Aumentar para liberar o percurso da lâmina |
| `BLADE_SLOT_Z` | Centro vertical da janela | Medir a altura do botão/dobradiça a partir da base traseira |
| `BLADE_SLOT_H` | Altura da janela no eixo Z | Ajustar para permitir acesso ao botão e passagem da lâmina |
| `BLADE_SLOT_R` | Raio dos cantos da janela | Usar pelo menos 1,5 mm para reduzir risco de rasgo |

A largura e a altura do slot podem ser aumentadas de forma independente. Porém, a posição `BLADE_SLOT_X` e o lado `BLADE_SLOT_SIDE` precisam estar corretos; aumentar a janela não corrige uma posição errada.

### Slot lateral genérico — BYD Yuan Pro e BYD Seal

Nos arquivos `byd_yuan_pro_bumper_v01.scad` e `byd_seal_bumper_v01.scad`, a abertura é controlada por:

| Variável | O que representa |
|---|---|
| `MECH_SLOT` | Liga ou desliga a abertura lateral |
| `MECH_SLOT_X` | Posição longitudinal da abertura |
| `MECH_SLOT_L` | Comprimento da abertura no eixo X |
| `MECH_SLOT_Z` | Posição vertical da abertura |
| `MECH_SLOT_H` | Altura da abertura no eixo Z |
| `MECH_SLOT_SIDE` | Lado da chave em que a abertura será feita |

Esses dois modelos usam inicialmente um slot genérico porque a geometria da chave física não foi confirmada. Se a chave Yuan Pro ou Seal for canivete, meça o percurso da lâmina antes de aumentar `MECH_SLOT_L` ou `MECH_SLOT_H`.

### Regra de atualização

Altere somente uma família de variáveis por vez. Primeiro atualize `KEY_L`, `KEY_W`, `KEY_T` e `KEY_R`; depois valide o encaixe. Em seguida ajuste o slot lateral e, por último, refine `CLR_*`, `LIP_IN` e `LIP_H`. Dessa forma será possível identificar qual alteração corrigiu ou causou cada problema.

Crie versões numeradas, por exemplo:

```text
geely_ex2_bumper_canivete_amostra01.scad
geely_ex2_bumper_canivete_amostra02.scad
byd_dolphin_bumper_canivete_amostra01.scad
```

Nunca substitua o arquivo-base original durante os testes.

---

## 1. Prepare ferramentas e identifique as chaves

Separe um paquímetro digital, régua metálica, lápis ou marcador, câmera do celular, balança opcional, TPU 95A seco, computador com OpenSCAD e o slicer da Elegoo. Identifique cada chave com uma etiqueta temporária: `EX2`, `DOLPHIN`, `YUAN` e `SEAL`.

Não meça apenas uma fotografia. A fotografia ajuda a registrar a posição dos elementos, mas as cotas principais devem ser obtidas diretamente na chave.

Antes de medir, confirme se a chave é do tipo canivete. Observe em qual lateral estão a dobradiça, o botão de liberação e o percurso da lâmina. Se não houver lâmina rebatível, o slot pode ser desligado com `BLADE_SLOT_ENABLE = false` ou `MECH_SLOT = false`, conforme o arquivo utilizado.

---

## 2. Faça a ficha de medição de cada modelo

Para cada chave, registre os valores abaixo em milímetros. Use sempre a mesma orientação: o eixo **X** vai da extremidade da argola para o topo da chave; **Y** é a largura; **Z** é a espessura.

| Medida | Como medir | Parâmetro |
|---|---|---|
| Comprimento máximo | Maior distância no corpo plástico, sem incluir argola metálica | `KEY_L` |
| Largura máxima | Maior largura perpendicular ao comprimento | `KEY_W` |
| Espessura máxima | Maior espessura, incluindo ressaltos e botões | `KEY_T` |
| Raio dos cantos | Medir ou aproximar comparando com raios conhecidos | `KEY_R` |
| Posição da janela da lâmina | Centro da dobradiça/botão ao longo de X | `BLADE_SLOT_X` ou `MECH_SLOT_X` |
| Altura da janela | Centro do mecanismo em relação à base traseira | `BLADE_SLOT_Z` ou `MECH_SLOT_Z` |
| Comprimento da janela | Espaço necessário no sentido X | `BLADE_SLOT_W` ou `MECH_SLOT_L` |
| Altura da janela | Espaço necessário no sentido Z | `BLADE_SLOT_H` ou `MECH_SLOT_H` |
| Lado do mecanismo | Parede Y positiva ou negativa | `BLADE_SLOT_SIDE` ou `MECH_SLOT_SIDE` |
| Passagem da argola | Abertura real para a argola/cinta | `RING_NOTCH_L/W` |

Meça também a distância entre a extremidade da chave e o centro do botão de liberação. Essa medida evita que o slot seja deslocado para uma região sem função.

### Folgas de partida recomendadas

Para TPU 95A, use inicialmente `CLR_X = 0,40 mm`, `CLR_Y = 0,25 mm por lado` e `CLR_Z = 0,35 mm`. Não use folga Z igual a zero na primeira amostra: uma capa de TPU sem folga pode travar durante a inserção ou pressionar a carcaça da chave.

Para a janela da lâmina, comece com pelo menos 1,0 mm ao redor da lâmina fechada. Se a lâmina precisar iniciar a abertura com a capa instalada, acrescente aproximadamente 1,5–2,0 mm no sentido do movimento. Use cantos com `BLADE_SLOT_R = 1,5 mm` ou maior.

---

## 3. Procedimento específico por modelo

### 3.1 Geely EX2

Abra `geely_ex2_bumper_canivete_v02.scad`. Substitua `KEY_L`, `KEY_W`, `KEY_T` e `KEY_R` pelas medidas da chave EX2. Depois defina `BLADE_SLOT_SIDE`, `BLADE_SLOT_X`, `BLADE_SLOT_W`, `BLADE_SLOT_Z` e `BLADE_SLOT_H` com base na posição real da dobradiça e do botão de liberação.

Para a primeira amostra, não tente obter uma janela mínima. É melhor começar ligeiramente maior, validar o movimento e depois reduzir em uma segunda versão. Confirme que o ressalto interno não passa sobre a dobradiça.

### 3.2 BYD Dolphin

Abra `byd_dolphin_bumper_canivete_v02.scad`. O manual oficial do Dolphin identifica lock, unlock, abertura do porta-malas, Start/Stop, indicador e chave mecânica. Por isso, a face dos controles deve permanecer completamente aberta e o slot não pode interferir na chave mecânica.

Substitua as medidas do corpo e ajuste o slot lateral. Se o mecanismo do canivete estiver na parede oposta à prevista, altere `BLADE_SLOT_SIDE` de `1` para `-1`.

### 3.3 BYD Yuan Pro

Abra `byd_yuan_pro_bumper_v01.scad`. Como a geometria da chave física do Yuan Pro não foi publicada oficialmente, trate a primeira peça como um protótipo de envelope. Atualize `KEY_L`, `KEY_W`, `KEY_T` e `KEY_R` com a chave real.

O arquivo utiliza `MECH_SLOT_*` como abertura lateral genérica. Se a chave Yuan Pro for canivete, verifique primeiro se o slot permite pressionar o botão de liberação e, depois, se a lâmina passa sem raspar. Não aumente a abertura automaticamente com base em anúncios comerciais.

### 3.4 BYD Seal

Abra `byd_seal_bumper_v01.scad`. O manual oficial do Seal identifica lock, unlock, trunk, Start/Stop, indicador e chave mecânica. A face precisa permanecer livre e a região de retirada da chave mecânica não pode ser coberta.

Meça principalmente a posição da chave mecânica e da dobradiça. Ajuste `MECH_SLOT_X`, `MECH_SLOT_L`, `MECH_SLOT_Z` e `MECH_SLOT_H`. Caso a chave seja canivete e o percurso exija uma janela maior, use como referência a lógica de `BLADE_SLOT_*` dos arquivos EX2 e Dolphin, mas confirme as medidas antes de copiar os valores.

---

## 4. Visualize e exporte no OpenSCAD

Abra o arquivo correspondente no OpenSCAD. Pressione **F5** para a visualização rápida e gire a peça para verificar três pontos: a base cobre a traseira, as paredes cobrem as laterais e a face dos botões está aberta.

Verifique especialmente se o slot lateral atravessa realmente a parede correta. Confirme também se o slot não está grande demais a ponto de cortar a parede de retenção ou deixar uma ponta fina de TPU.

Quando a geometria estiver coerente, pressione **F6** para renderizar a peça completa. Depois use **File > Export > Export as STL**. Salve com nomes claros, por exemplo:

```text
EX2_bumper_canivete_amostra01.stl
Dolphin_bumper_canivete_amostra01.stl
YuanPro_bumper_amostra01.stl
Seal_bumper_amostra01.stl
```

Não sobrescreva os arquivos SCAD originais. Crie uma cópia de trabalho com sufixo `_amostra01`.

---

## 5. Importação do STL e ajuste de encaixes no Fusion 360

O Fusion 360 não abre o arquivo `.scad` como um modelo paramétrico nativo. O fluxo recomendado é gerar um STL no OpenSCAD, importar a malha no Fusion 360 e usar o Fusion para medir interferências, criar um corpo de referência da chave e realizar pequenos ajustes locais.

### Importar o STL

No OpenSCAD, pressione **F6** e exporte com **File > Export > Export as STL**. No Fusion 360, use **Insert > Insert Mesh** ou envie o arquivo pelo painel de dados e insira-o no projeto atual. Confirme que a unidade está em **milímetros** e use a base traseira da capa como referência de orientação.

Depois de importar, use **Inspect > Measure** para confirmar uma dimensão conhecida. Se o modelo ficar 25,4 vezes maior ou menor, a unidade foi interpretada incorretamente como polegada ou milímetro.

### Converter a malha, se necessário

Para pequenos ajustes, a malha STL pode ser suficiente. Se precisar editar faces, procure **Mesh > Modify > Convert Mesh** ou **Mesh to BRep**, conforme a versão do Fusion 360. Se a conversão ficar pesada, use antes **Mesh > Modify > Reduce** com redução moderada.

A conversão para BRep não recupera as variáveis paramétricas do OpenSCAD. Os parâmetros `KEY_L`, `KEY_W`, `KEY_T`, `BLADE_SLOT_*` e `MECH_SLOT_*` continuam editáveis somente no arquivo `.scad`.

### Criar um corpo de referência da chave

Para verificar o encaixe, crie no Fusion 360 um novo componente chamado `CHAVE_REFERENCIA`. Faça um sketch com o contorno medido da chave, aplique os raios dos cantos e faça uma extrusão com a espessura `KEY_T`. Coloque esse corpo dentro da capa importada.

Use **Inspect > Interference** para procurar colisões entre `CHAVE_REFERENCIA` e a capa. Verifique também se a face dos botões permanece livre, se o ressalto não bloqueia a inserção e se a lâmina alcança o slot sem raspar.

### Correspondência entre o problema e a variável

| Problema observado no Fusion 360 | Variável a alterar no OpenSCAD |
|---|---|
| Chave não entra no comprimento | `KEY_L` ou `CLR_X` |
| Capa estreita nas laterais | `KEY_W` ou `CLR_Y` |
| Chave encosta na traseira | `KEY_T` ou `CLR_Z` |
| Slot está no lugar errado | `BLADE_SLOT_X`/`BLADE_SLOT_Z` ou `MECH_SLOT_X`/`MECH_SLOT_Z` |
| Slot está curto | `BLADE_SLOT_W` ou `MECH_SLOT_L` |
| Slot está baixo ou estreito | `BLADE_SLOT_H` ou `MECH_SLOT_H` |
| Slot está na lateral errada | `BLADE_SLOT_SIDE` ou `MECH_SLOT_SIDE` |
| Capa escapa da chave | `LIP_IN` ou `LIP_H` |
| Parede encosta nos botões | `FACE_CLEARANCE` |
| Abertura da argola incorreta | `RING_NOTCH_L` ou `RING_NOTCH_W` |

Para ajustes dimensionais principais, volte ao OpenSCAD, altere uma família de parâmetros por vez, pressione **F6**, exporte um novo STL e importe a nova versão no Fusion. Evite usar **Scale** para corrigir o encaixe, porque a escala global também altera paredes, slot, ressalto e folgas.

### Fluxo de ajuste

```text
Medir a interferência no Fusion 360
        ↓
Identificar a variável correspondente
        ↓
Alterar o arquivo .scad
        ↓
Pressionar F6 no OpenSCAD
        ↓
Exportar novo STL
        ↓
Importar no Fusion 360
        ↓
Medir novamente
        ↓
Criar amostra02
```

---

## 6. Prepare o TPU e a Elegoo CC2

Use TPU 95A seco. Se o filamento ficou exposto ao ar por muito tempo, seque-o conforme a recomendação do fabricante antes de imprimir. O TPU úmido costuma produzir fios, bolhas e variações dimensionais.

Na Centauri Carbon 2/CC2, siga o procedimento oficial da ELEGOO para instalar o adaptador de TPU e selecionar TPU no equipamento e no slicer. A documentação oficial informa 35 °C como temperatura padrão da mesa para TPU; não substitua esse valor automaticamente por um perfil de PLA ou PETG [1].

Carregue o filamento devagar, confirme que ele chegou ao hotend e faça uma pequena extrusão antes de iniciar a impressão. O objetivo é verificar que o filamento flexível não está dobrando ou travando no caminho.

---

## 7. Configuração inicial no slicer

Use a seguinte configuração como ponto de partida, não como perfil definitivo:

| Configuração | Valor inicial |
|---|---:|
| Material | TPU 95A |
| Altura de camada | 0,20 mm |
| Largura de linha | 0,42–0,48 mm com bico de 0,4 mm |
| Paredes | 3 perímetros |
| Camadas inferiores | 4 |
| Camadas superiores | 0–2, pois a face frontal é aberta |
| Infill | 0% ou o mínimo necessário; a base já é uma parede sólida |
| Velocidade geral | 20–35 mm/s |
| Parede externa | 20–25 mm/s |
| Primeira camada | 15–20 mm/s |
| Mesa | 35 °C como ponto de partida oficial |
| Suportes | Desligados inicialmente |
| Retração | Usar o perfil do fabricante; calibrar se houver stringing excessivo |

A orientação recomendada é com a **base traseira totalmente apoiada na mesa** e a face aberta voltada para cima. Isso deixa a traseira uniforme e evita suportes no interior da capa.

Não use automaticamente 100% de infill. Em um bumper de TPU, a base e as paredes perimetrais já formam a estrutura principal; infill elevado pode aumentar tempo, rigidez e dificuldade de remoção sem melhorar o encaixe.

---

## 8. Imprima a primeira amostra

Antes de iniciar, confira se o bico está limpo, se a mesa está nivelada e se a bobina desenrola sem resistência. Inicie a impressão e observe pessoalmente os primeiros minutos.

Na primeira camada, verifique se o TPU está aderindo sem ser excessivamente esmagado. Se a linha ficar muito achatada, houver acúmulo na ponta do bico ou a peça estiver se deformando, interrompa e corrija a altura inicial antes de continuar.

Durante as paredes laterais, observe se o slot está formando bordas contínuas e se os cantos arredondados não estão criando falhas. Não remova a peça ainda quente; espere o resfriamento e retire-a sem puxar agressivamente as paredes.

---

## 9. Teste de encaixe de cada amostra

Faça o teste sem apertar a chave contra a peça. Primeiro insira a extremidade oposta à argola, depois acomode a parte traseira e finalmente pressione as laterais para dentro do ressalto de retenção.

Use a seguinte sequência de verificação:

| Teste | Critério de aprovação |
|---|---|
| Inserção | A chave entra sem precisar forçar ou dobrar excessivamente o TPU |
| Retenção | A capa não cai quando a chave é virada de cabeça para baixo |
| Botões | Todos os botões podem ser pressionados sem a capa interferir |
| Indicador | O LED/indicador permanece visível, quando existente |
| Argola | A cinta ou argola passa sem rasgar o TPU |
| Slot lateral | O botão de liberação pode ser alcançado |
| Lâmina | A lâmina abre e fecha sem travar ou raspar excessivamente |
| Remoção | A chave pode ser retirada sem danificar a capa ou a carcaça |

Se a lâmina travar, não force. Aumente primeiro `BLADE_SLOT_W` ou `BLADE_SLOT_H` em incrementos de 1–2 mm. Se a janela estiver no lugar errado, ajuste `BLADE_SLOT_X` ou `MECH_SLOT_X`; aumentar a abertura não corrige uma posição incorreta.

---

## 10. Como registrar a primeira amostra

Anote para cada peça o nome do arquivo, lote do TPU, temperatura, velocidade, valor de fluxo, folgas utilizadas e resultado do teste. Fotografe a chave instalada pela frente, traseira e lateral do slot.

Use uma classificação simples:

| Resultado | Ação |
|---|---|
| Encaixe frouxo | Reduzir a folga em 0,10–0,20 mm ou aumentar levemente o ressalto |
| Encaixe muito apertado | Aumentar `CLR_Y`/`CLR_Z` em 0,10–0,20 mm |
| Botão bloqueado | Rebaixar ou afastar a parede; não aumentar força de acionamento |
| Lâmina raspa | Aumentar `BLADE_SLOT_W/H` ou corrigir a posição |
| Parede rasga | Aumentar `BLADE_SLOT_R` e evitar janela muito próxima de um canto |
| Capa gira na chave | Melhorar o ressalto ou reduzir folga longitudinal |
| Muitos fios | Secar o TPU e calibrar retração/temperatura |

Depois do primeiro teste, crie a versão `amostra02`. Nunca altere a amostra01; ela é o registro de comparação.

---

## Checklist final antes da impressão

Confirme que a chave foi medida, que os eixos X/Y/Z foram aplicados corretamente, que o slot está no lado certo, que a janela não corta o ressalto de retenção e que a face dos botões está realmente aberta. Verifique também se a argola e a chave mecânica permanecem acessíveis.

A primeira amostra deve ser impressa lentamente e observada durante a primeira camada. O objetivo não é obter acabamento perfeito, mas validar **geometria, função e segurança de uso**.

## Referências

[1]: https://wiki.elegoo.com/centauri-carbon-2-combo/how-to-print-tpu "ELEGOO Wiki — How to Install the TPU Adapter and Print TPU"

[2]: https://www.bydauto.ie/assets/1/owners/owners-manuals/byd-dolphin-owners-manual-right-hand-drive-en.pdf "BYD Dolphin Owner's Manual"

[3]: https://www.bydauto.co.nz/storage/uploads/584dac99-9035-4e65-9354-42c1b8162793/BYD-SEAL-OWNER%E2%80%98s-MANUAL-NZ_11_2023_web.pdf "BYD Seal Owner's Manual"

[4]: https://www.byd.com/br/noticias-byd-brasil/byd-yuan-pro-chega--para-ocupar-o-posto-de-primeiro-suv-100--ele "BYD Brasil — Yuan Pro"
