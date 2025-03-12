<?xml version='1.0' encoding="iso-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>
  <xsl:template match="phrase[@role='red']">
    <xsl:text>
        \textcolor{red}{
    </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>
        }
    </xsl:text>
  </xsl:template>
  <xsl:template match="phrase[@role='blue-background']">
    <xsl:text>
        \sethlcolor{blue}\hl{
    </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>
        }
    </xsl:text>
  </xsl:template>
  <xsl:template match="phrase[@role='green-background']">
    <xsl:text>
        \sethlcolor{green}\hl{
    </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>
        }
    </xsl:text>
  </xsl:template>

  <xsl:template match="section/simpara">
      <xsl:text>
\p </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>

</xsl:text>
  </xsl:template>

  <xsl:template match="part|chapter|appendix|
                       sect1|sect2|sect3|sect4|sect5|section" mode="label.markup">
    <xsl:text>\ref{</xsl:text>
    <xsl:value-of select="(@id|@xml:id)[1]"/>
    <xsl:text>}</xsl:text>
  </xsl:template>


  <xsl:param name="xref.with.number.and.title" select="1"></xsl:param>

  <xsl:param name="local.l10n.xml" select="document('')"/>
  <l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
    <l:l10n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0" language="en">
     <l:context name="xref-number-and-title">
        <l:template name="section" text="Section %n, %t"/>
      </l:context>
    </l:l10n>
  </l:i18n>

  <xsl:template match="itemizedlist">
      <xsl:text>\vspace{-6pt}</xsl:text> <!-- Reduce space before list -->
      <xsl:text>\begin{itemize}\setlength{\itemsep}{2pt}\setlength{\parskip}{0pt}\setlength{\topsep}{0pt}\setlength{\partopsep}{0pt}</xsl:text>
      <xsl:apply-templates/>
    <xsl:text>\end{itemize}</xsl:text>
      <xsl:text>\vspace{-6pt}</xsl:text> <!-- Reduce space after list -->
  </xsl:template>

</xsl:stylesheet>
