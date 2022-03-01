# Sefazclass

Classe com fun��es pra Sefaz

Crie e/ou altere \harbour\bin\hbmk.hbc

acrescente

libpaths=pasta do arquivo sefazclass.hbc


# Como funciona o Webservice do governo:

Entregar XML e receber uma resposta.

No geral, a autoriza��o de documentos envolve duas etapas:

1. Entrega o XML que retorna um n�mero de recibo (ou erro)
2. Consulta esse recibo que retorna o protocolo (ou erro)

J� outras etapas: cancelamento, carta de corre��o, inutiliza��o, etc. envolve apenas uma etapa:

1. Entrega o XML e j� obt�m o protocolo (ou erro)

# E a Sefazclass:

Tem eventos que tratam cada etapa.

- Autoriza��o de NFE, CTE, MDFE: NfeLoteEnvia(), CteLoteEnvia(), MDFeLoteEnvia()
- Cancelamento:  NfeEventoCancela(), CteEventoCancela(), MDFeEventoCancela()
- Carta de corre��o: NfeEventoCarta(), CteEventoCarta()
- Inutiliza��o: NfeInutiliza(), CteInutiliza()
- Outros eventos: CteEventoDesacordo(), MdfeEventoEncerramento(), MdfeEventoInclusaoCondutor(), NfeEventoManifestacao()

Verifique o nome dos par�metros e saber� o que informar.
D�vidas, consulte o manual da SEFAZ, que cont�m todos os detalhes.

# Considera��es:

- A Sefazclass n�o trata arquivos XMLs, e sim o conte�do. cXML representa o conte�do do XML
- cCertificado � o nome do certificado, veja em propriedades do certificado o CN=

A Sefazclass n�o inventa nada, tudo est� dentro dos manuais do governo.

Para entregar os XMLs, cada UF ou servi�o � para um endere�o de internet diferente.
Nos fontes da Sefazclass j� tem muitos desses endere�os, mas n�o significa que tem todos, ou que est�o atualizados.
Cabe ao usu�rio da classe fazer os testes finais e informar algum endere�o errado ou inexistente.

# Atualizada at�:

NFE 4.00
NFCE 4.00
CTE 3.00
MDFE 3.00
