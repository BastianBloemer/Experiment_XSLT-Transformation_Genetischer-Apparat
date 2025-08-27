<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:template match="/">
        <html>
            <head>
                <title>Faust – Prosaentwurf (HTML)</title>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                <style>
                    .add-1 {
                        position: relative;
                        top: 1em;
                    }
                    .add-2 {
                        position: relative;
                        top: 2em;
                    }
                    span {
                        font-weight: bold;
                    }
                    .del {
                        font-weight: normal;
                    }</style>
            </head>
            <body>
                <h1>Faust - Synoptischer Apparat</h1>
                <ol>
                    <xsl:apply-templates
                        select="xml/zone[@type = 'main']/line[not(@type = 'inter' or @rend = 'indent-70')]"
                    />
                </ol>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="line">
        <li>
            <span class="line">
                <xsl:apply-templates/>
                <xsl:if test="following-sibling::*[1][self::line and @rend = 'indent-70']">
                    <xsl:value-of
                        select="following-sibling::*[1][self::line and @rend = 'indent-70']"/>
                </xsl:if>
            </span>
            <br/>
            <br/>
        </li>
    </xsl:template>
    <xsl:template match="mod">
        <span class="del"> [<xsl:apply-templates/>]</span>
    </xsl:template>
    <xsl:template match="anchor">
        <xsl:variable name="anchor-id" select="concat('#', @xml:id)"/>
        <xsl:variable name="line-refs" select="//line[@type = 'inter'] | //ins"/>
        <xsl:variable name="zone-refs" select="//zone[not(@type = 'main')]"/>
        <xsl:for-each select="$line-refs[@* = $anchor-id]">
            <xsl:variable name="line-refs-id" select="concat('#', @xml:id)"/>
            <span class="add-1">
                <xsl:apply-templates select="node()"/>
            </span>
            <xsl:if test="$zone-refs[@* = $line-refs-id]">
                <span class="add-2">
                    <xsl:value-of select="$zone-refs[@* = $line-refs-id]"/>
                </span>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
