# KeyBumperSync — add-in local do Fusion 360



Este add-in roda **localmente dentro do Autodesk Fusion 360**. Ele não é executado pelo GitHub Actions.



## O que ele faz



Ao clicar no comando **Key Bumper Sync**, o add-in:



1. solicita um arquivo STL gerado pelo OpenSCAD/GitHub Actions;
2. 
2. insere o STL como malha no documento de design ativo;
3. 
3. solicita opcionalmente um CSV de parâmetros medidos;
4. 
4. cria ou atualiza User Parameters numéricos e Attributes para uso na inspeção.
5. 


## Instalação no macOS



1. Feche o Fusion 360.
2. 
2. Copie a pasta `KeyBumperSync.bundle` para:
3. 


```text

~/Library/Application Support/Autodesk/Autodesk Fusion 360/API/AddIns/

```



3. Abra o Fusion 360.
4. 
4. Vá a **Utilities > Add-Ins > Add-Ins**.
5. 
5. Selecione `KeyBumperSync`.
6. 
6. Clique em **Run**. Para iniciar automaticamente, marque **Run on Startup**.
7. 


No Windows, use a pasta de AddIns do Fusion 360 indicada pelo gerenciador de Scripts and Add-Ins.



## Uso



Abra um design novo ou existente, execute o add-in e selecione o STL. Quando a segunda caixa de seleção aparecer, escolha o CSV do modelo, por exemplo `models/parameters/geely_ex2.csv`.



O add-in importa a malha usando a Fusion API. Depois use o ambiente **Mesh**, **Inspect > Measure** e, se necessário, **Inspect > Interference** com um corpo `CHAVE_REFERENCIA` criado manualmente.



## Limites



A malha STL não se torna automaticamente um modelo paramétrico nativo. Os valores editáveis continuam no SCAD e nos CSV. O add-in não decide dimensões, não corrige automaticamente folgas e não executa o Fusion fora do computador do usuário.



O código usa a Fusion API para `ImportManager.createSTLImportOptions`/`importToTarget` e para User Parameters. Confirme a API disponível na sua versão do Fusion se a Autodesk alterar nomes ou permissões.











