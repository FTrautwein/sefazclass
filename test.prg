REQUEST HB_CODEPAGE_PTISO

#include "inkey.ch"
#include "set.ch"
#include "hbgtinfo.ch"

PROCEDURE Main

   LOCAL nOpc := 1, GetList := {}, cTexto := "", nOpcTemp
   LOCAL cCnpj := Space(14), cChave := Space(44), cCertificado := "", cUF := "SP", cXmlRetorno
   LOCAL oSefaz, cXml

   SET DATE BRITISH
   SetupHarbour()
   SetMode( 33, 80 )
   Set( _SET_CODEPAGE, "PTISO" )
   SetColor( "W/B,N/W,,,W/B" )

   oSefaz     := SefazClass():New()
   oSefaz:cUF := "SP"

   DO WHILE .T.
      CLS
      @ Row() + 1, 5 PROMPT "Teste Danfe"
      @ Row() + 1, 5 PROMPT "Seleciona certificado"
      @ Row() + 1, 5 PROMPT "UF Default"
      @ Row() + 1, 5 PROMPT "Consulta Status NFE"
      @ Row() + 1, 5 PROMPT "Consulta Cadastro"
      @ Row() + 1, 5 PROMPT "Protocolo NFE"
      @ Row() + 1, 5 PROMPT "Protocolo CTE"
      @ Row() + 1, 5 PROMPT "Protocolo MDFE"
      @ Row() + 1, 5 PROMPT "Consulta Destinadas"
      @ Row() + 1, 5 PROMPT "Valida XML"
      MENU TO nOpc
      nOpcTemp := 1
      DO CASE
      CASE LastKey() == K_ESC
         EXIT

      CASE nOpc == nOpcTemp++
         TestDanfe()

      CASE nOpc == nOpcTemp++
         oSefaz:cCertificado := CapicomEscolheCertificado()
         wapi_MessageBox( , oSefaz:cCertificado )
         LOOP

      CASE nOpc == nOpcTemp++
         Scroll( 8, 0, MaxRow(), MaxCol(), 0 )
         @ 8, 0 SAY "Qual UF:" GET oSefaz:cUF PICTURE "@!"
         READ

      CASE nOpc == nOpcTemp++
         cXmlRetorno := oSefaz:NfeStatus()
         wapi_MessageBox( , oSefaz:cXmlSoap, "XML enviado" )
         wapi_MessageBox( , oSefaz:cXmlRetorno, "XML retornado" )
         cTexto := "Tipo Ambiente:"     + XmlNode( cXmlRetorno, "tpAmb" ) + HB_EOL()
         cTexto += "Vers�o Aplicativo:" + XmlNode( cXmlRetorno, "verAplic" ) + HB_EOL()
         cTexto += "Status:"            + XmlNode( cXmlRetorno, "cStat" ) + HB_EOL()
         cTexto += "Motivo:"            + XmlNode( cXmlRetorno, "xMotivo" ) + HB_EOL()
         cTexto += "UF:"                + XmlNode( cXmlRetorno, "cUF" ) + HB_EOL()
         cTexto += "Data/Hora:"         + XmlNode( cXmlRetorno, "dhRecbto" ) + HB_EOL()
         cTexto += "Tempo M�dio:"       + XmlNode( cXmlRetorno, "tMed" ) + HB_EOL()
         wapi_MessageBox( , cTexto, "Informa��o Extra�da" )

      CASE nOpc == nOpcTemp++
         Scroll( 8, 0, MaxRow(), MaxCol(), 0 )
         @ 8, 0 SAY "UF"   GET cUF PICTURE "@!"
         @ 9, 0 SAY "CNPJ" GET cCnpj PICTURE "@R 99.999.999/9999-99"
         READ
         IF LastKey() == K_ESC
            LOOP
         ENDIF
         Scroll( 8, 0, MaxRow(), MaxCol(), 0 )
         oSefaz:cProjeto := "nfe"
         cXmlRetorno := oSefaz:NfeCadastro( cCnpj, cUF )
         wapi_MessageBox( , oSefaz:cXmlSoap, "XML Enviado" )
         wapi_MessageBox( , oSefaz:cXmlRetorno, "XML Retornado" )
         cTexto := "versao:    " + XmlNode( cXmlRetorno, "versao" ) + HB_EOL()
         cTexto += "Aplicativo:" + XmlNode( cXmlRetorno, "verAplic" ) + HB_EOL()
         cTexto += "Status:    " + XmlNode( cXmlRetorno, "cStat" ) + HB_EOL()
         cTexto += "Motivo:    " + XmlNode( cXmlRetorno, "xMotivo" ) + HB_EOL()
         cTexto += "UF:        " + XmlNode( cXmlRetorno, "UF" ) + HB_EOL()
         cTexto += "IE:        " + XmlNode( cXmlRetorno, "IE" ) + HB_EOL()
         cTexto += "CNPJ:      " + XmlNode( cXmlRetorno, "CNPJ" ) + HB_EOL()
         cTexto += "CPF:       " + XmlNode( cXmlRetorno, "CPF" ) + HB_EOL()
         cTexto += "Data/Hora: " + XmlNode( cXmlRetorno, "dhCons" ) + HB_EOL()
         cTexto += "UF:        " + XmlNode( cXmlRetorno, "cUF" ) + HB_EOL()
         cTexto += "Nome(1):   " + XmlNode( cXmlRetorno, "xNome" ) + HB_EOL()
         cTexto += "CNAE(1):   " + XmlNode( cXmlRetorno, "CNAE" ) + HB_EOL()
         cTexto += "Lograd(1): " + XmlNode( cXmlRetorno, "xLgr" ) + HB_EOL()
         cTexto += "nro(1):    " + XmlNode( cXmlRetorno, "nro" ) + HB_EOL()
         cTexto += "Compl(1):  " + XmlNode( cXmlRetorno, "xCpl" ) + HB_EOL()
         cTexto += "Bairro(1): " + XmlNode( cXmlRetorno, "xBairro" ) + HB_EOL()
         cTexto += "Cod.Mun(1):" + XmlNode( cXmlRetorno, "cMun" ) + HB_EOL()
         cTexto += "Municip(1):" + XmlNode( cXmlRetorno, "xMun" ) + HB_EOL()
         cTexto += "CEP(1):    " + XmlNode( cXmlRetorno, "CEP" ) + HB_EOL()
         cTexto += "Etc pode ter v�rios endere�os..."
         wapi_MessageBox( , cTexto, "Informa��o Extra�da" )

      CASE nOpc == nOpcTemp++
         Scroll( 8, 0, MaxRow(), MaxCol(), 0 )
         @ 8, 1 GET cChave PICTURE "@R 99-99/99-99.999.999/9999-99.99.999.999999999.9.99999999.9"
         READ
         IF LastKey() == K_ESC
            EXIT
         ENDIF
         oSefaz:NfeConsulta( cChave )
         wapi_MessageBox( , oSefaz:cXmlSoap )
         wapi_MessageBox( , oSefaz:cXmlRetorno )

      CASE nOpc == nOpcTemp++
         Scroll( 8, 0, MaxRow(), MaxCol(), 0 )
         @ 8, 1 GET cChave PICTURE "@R 99-99/99-99.999.999/9999-99.99.999.999999999.9.99999999.9"
         READ
         IF LastKey() == K_ESC
            EXIT
         ENDIF
         oSefaz:CteConsulta( cChave, cCertificado )
         wapi_MessageBox( , oSefaz:cXmlSoap )
         wapi_MessageBox( , oSefaz:cXmlRetorno )

      CASE nOpc == nOpcTemp++
         Scroll( 8, 0, MaxRow(), MaxCol(), 0 )
         @ 8, 1 GET cChave PICTURE "@R 99-99/99-99.999.999/9999-99.99.999.999999999.9.99999999.9"
         READ
         IF LastKey() == K_ESC
            EXIT
         ENDIF
         oSefaz:MDFeConsulta( cChave, cCertificado )
         wapi_MessageBox( , oSefaz:cXmlSoap )
         wapi_MessageBox( , oSefaz:cXmlRetorno )

      CASE nOpc == nOpcTemp++
         Scroll( 8, 0, MaxRow(), MaxCol(), 0 )
         @ 9, 1 GET cCnpj PICTURE "@9"
         READ
         IF LastKey() == K_ESC
            EXIT
         ENDIF
         oSefaz:nfeDistribuicaoDFe( cCnpj, "0" )
         wapi_MessageBox( , oSefaz:cXmlSoap )
         wapi_MessageBox( , oSefaz:cXmlRetorno )

         oSefaz:nfeConsultaDest( cCnpj, "0" )
         wapi_MessageBox( , oSefaz:cXmlSoap )
         wapi_MessageBox( , oSefaz:cXmlRetorno )

      CASE nOpc == 10
         cXml := MemoRead( "d:\temp\teste.xml" )
         // cXml := StrTran( cXml, "</NFe>", FakeSignature() + "</NFe>" )
         ? oSefaz:ValidaXml( cXml, "d:\cdrom\fontes\integra\schemmas\pl_008i2_cfop_externo\nfe_v3.10.xsd" )
         Inkey(0)

      CASE nOpc == nOpcTemp  // pra n�o esquecer o ++, �ltimo n�o tem

      ENDCASE
   ENDDO

   RETURN

FUNCTION SetupHarbour()

#ifndef __XHARBOUR__
   hb_gtInfo( HB_GTI_INKEYFILTER, { | nKey | MyInkeyFilter( nKey ) } ) // pra funcionar control-V
#endif
   SET( _SET_EVENTMASK, INKEY_ALL - INKEY_MOVE )
   SET CONFIRM ON
   RETURN NIL


#ifndef __XHARBOUR__
// rotina do ctrl-v
FUNCTION MyInkeyFilter( nKey )

   LOCAL nBits, lIsKeyCtrl

   nBits := hb_GtInfo( HB_GTI_KBDSHIFTS )
   lIsKeyCtrl := ( nBits == hb_BitOr( nBits, HB_GTI_KBD_CTRL ) )
   SWITCH nKey
   CASE K_CTRL_V
      IF lIsKeyCtrl
         hb_GtInfo( HB_GTI_CLIPBOARDPASTE )
         RETURN 0
      ENDIF
   ENDSWITCH
   RETURN nKey
#endif

FUNCTION TestDanfe()

   LOCAL oDanfe, oFiles, cFileXml, cFilePdf

   oFiles := { "ctecarbolub.xml", "eventoctealguem.xml", "eventoctecarbolub.xml", ;
        "eventonfecordeiro.xml", "eventonfecordeiro2.xml", "mdfecordeiro.xml", ;
        "mdfecordeiro2.xml", "nfecarbolub.xml", "nfecordeiro.xml", "nfemaringa.xml", ;
        "nfeasper.xml", "nfeenzza.xml" }
   FOR EACH cFileXml IN oFiles
      DO CASE
      CASE Left( cFileXml, 3 ) == "cte" ;       oDanfe := hbNFeDaCte():New()
      CASE Left( cFileXml, 3 ) == "nfe" ;       oDanfe := hbNFeDaNfe():New()
      CASE Left( cFileXml, 9 ) == "eventocte" ; oDanfe := hbNFeDaEvento():New()
      CASE Left( cFileXml, 9 ) == "eventonfe" ; oDanfe := hbNFeDaEvento():New()
      ENDCASE
      cFilePdf := Substr( cFileXml, 1, At( ".", cFileXml ) ) + "pdf"
      fErase( cFilePdf )
      oDanfe:cLogoFile := JPEGImage()
      oDanfe:cDesenvolvedor := "www.jpatecnologia.com.br"
      IF Left( cFileXml, 6 ) == "evento"
         oDanfe:Execute( MemoRead( cFileXml ), iif( File( Substr( cFileXml, 7 ) ), MemoRead( Substr( cFileXml, 7 ) ), "" ), cFilePdf )
      ELSE
         oDanfe:Execute( MemoRead( cFileXml ), cFilePdf )
      ENDIF
      ? oDanfe:cRetorno
      PDFOpen( cFilePdf )
   NEXT
   oDanfe := hbNFeDaNFCe():New()
   oDanfe:Execute( "www.jpatecnologia.com.br", "pdfqrcode.pdf" )
   PDFOpen( "pdfqrcode.pdf" )
   Inkey(0)

   RETURN NIL

FUNCTION PDFOpen( cFile )

   IF File( cFile )
      WAPI_ShellExecute( NIL, "open", cFile, "",, WIN_SW_SHOWNORMAL )
      Inkey(1)
   ENDIF

   RETURN NIL

FUNCTION JPEGImage()

   #pragma __binarystreaminclude "jpatecnologia.jpg"        | RETURN %s
