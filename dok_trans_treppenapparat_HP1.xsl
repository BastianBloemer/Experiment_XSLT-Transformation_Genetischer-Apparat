<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0">
  <xsl:output method="html" indent="yes" html-version="5" encoding="UTF-8"/>
  <xsl:template match="/xml">
    <html>
      <head>
        <title>Faust – Prosaentwurf (HTML)</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <style>
          .inline-sublist {
              display: inline-flex;
              flex-direction: column;
              margin: 0;
              padding: 0;
              list-style: none;
          }
          .inline-sublist > li {
              display: block;
              counter-increment: item;
          }
          .inline-sublist > li::before {
              content: counters(item, ".") ".";
              margin-right: 0.5em;
              margin-left: 0.5em;
              font-weight: bold;
          }
          .inline-sublist > li:first-child {
              display: inline-flex;
          }
          ol li::marker {
              font-weight: bold;
          }</style>
      </head>
      <body>
        <h1>Faust - Stufenapparat</h1>
        <ol>
          <xsl:apply-templates
            select="//line[not(@type = 'inter') and not(starts-with(@rend, 'indent'))]"/>
        </ol>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="line">
    <li>
      <ol>
        <li>
          <xsl:apply-templates select="node()[not(self::anchor) and not(preceding-sibling::anchor)]"
          />
        </li>
        <xsl:if test="not(child::*[not(self::mod)])">
          <li/>
        </xsl:if>
        <xsl:if test="anchor[not(../mod)]">
          <li>
            <xsl:apply-templates select="node()[not(preceding-sibling::anchor)]"
              mode="replace-anchor-with-id"/>
          </li>
        </xsl:if>
        <xsl:if test="anchor">
          <li>
            <xsl:choose>
              <xsl:when test="mod">
                <xsl:variable name="lastMod" select="mod"/>
                <xsl:apply-templates select="node()[. &lt;&lt; $lastMod]"
                  mode="replace-anchor-with-id-zones"/>
                <ol class="inline-sublist">
                  <li>
                    <xsl:value-of select="$lastMod"/>
                  </li>
                  <li>
                    <xsl:variable name="afterMod" select="$lastMod/following-sibling::text()"/>
                    <xsl:variable name="indentLine"
                      select="following-sibling::line[@rend = 'indent-70'][1]"/>
                    <xsl:value-of select="concat($afterMod, ' ', $indentLine)"/>
                  </li>
                </ol>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="node()" mode="replace-anchor-with-id-zones"/>
              </xsl:otherwise>
            </xsl:choose>
          </li>
        </xsl:if>
      </ol>
      <p/>
    </li>
  </xsl:template>
  <xsl:variable name="refs" select="//line[@type = 'inter'] | //ins"/>
  <xsl:variable name="zone-refs" select="//zone[not(@type = 'main')]"/>
  <xsl:template match="anchor" mode="replace-anchor-with-id">
    <xsl:variable name="hash" select="concat('#', @xml:id)"/>
    <xsl:for-each select="$refs[@* = $hash]">
      <xsl:apply-templates select="node()"/>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="anchor" mode="replace-anchor-with-id-zones">
    <xsl:variable name="hash" select="concat('#', @xml:id)"/>
    <xsl:for-each select="$refs[@* = $hash]">
      <xsl:apply-templates select="node()"/>
      <xsl:variable name="current-id" select="concat('#', @xml:id)"/>
      <xsl:if test="exists($zone-refs[@* = $current-id])">
        <xsl:value-of select="$zone-refs[@* = $current-id]"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
