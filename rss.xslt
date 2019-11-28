<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" version="1.0">
  <xsl:output method="html" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"/>
  <xsl:variable name="title" select="/rss/channel/title"/>
  <xsl:variable name="feedDesc" select="/rss/channel/description"/>
  <xsl:variable name="copyright" select="/rss/channel/copyright"/>
  <xsl:variable name="feedUrl" select="/rss/channel/atom:link[@rel='self']/@href" xmlns:atom="http://www.w3.org/2005/Atom"/>
  <xsl:variable name="baseURL" select="''" xmlns:atom="http://www.w3.org/2005/Atom"/>
  <!-- <xsl:variable name="baseURL" select="'https://bronoverrattvik.github.io'" xmlns:atom="http://www.w3.org/2005/Atom"/> -->

  <xsl:template match="/">
    <xsl:element name="html">
      <head>
        <title><xsl:value-of select="$title"/></title>
        <!-- <link href="{$baseURL}/styles.css" rel="stylesheet" type="text/css" media="all"/> -->
        <link href="{$baseURL}/assets/main.css" rel="stylesheet" type="text/css" media="all"/>
      </head>
      <xsl:apply-templates select="rss/channel"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="channel">
    <body class="rss-xslt">
      <main class="page-content" aria-label="Content">
        <div class="wrapper">
          <div class="info">
            <xsl:apply-templates select="image"/>
            <h1 class="page-heading">
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:value-of select="/rss/channel/link[1]" xmlns:atom="http://www.w3.org/2005/Atom"/>
                </xsl:attribute>
                <xsl:attribute name="title">Link to original website</xsl:attribute>
                <xsl:value-of select="$title"/>
              </xsl:element>
            </h1>
            <p id="desctext"><xsl:value-of select="$feedDesc"/></p>
            <p class="copyright">
              <xsl:value-of select="$copyright"/>
            </p>
          </div>
          <ul xmlns="http://www.w3.org/1999/xhtml" class="post-list">
            <xsl:apply-templates select="item"/>
          </ul>
        </div>
        <footer class="site-footer">
          <div class="wrapper">
            <h2 class="footer-heading"><a href="{$baseURL}/">Bron över Rättvik</a></h2>
          </div>
        </footer>
      </main>
    </body>
  </xsl:template>

  <xsl:template match="item" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:atom="http://www.w3.org/2005/Atom">
      <li>
        <span class="post-meta">
          <xsl:if test="count(child::pubDate)=1"><xsl:value-of select="substring(pubDate, 0, 17)"/></xsl:if>
          <xsl:if test="count(child::dc:date)=1"><xsl:value-of select="dc:date"/></xsl:if>
        </span>

        <h2>
          <a href="{link}">
            <xsl:value-of select="title"/>
          </a>
        </h2>

        <div class="mediaenclosure">
          <xsl:if test="count(child::enclosure)&gt;0">
            <xsl:if test="contains(enclosure/@type, 'video')">
              <xsl:element name="video" namespace="http://www.w3.org/1999/xhtml">
                <xsl:attribute name="width">320</xsl:attribute>
                <xsl:attribute name="height">180</xsl:attribute>
                <xsl:attribute name="controls" />
                <xsl:attribute name="class">vplayer</xsl:attribute>
                <xsl:if test="position() = 1">
                  <xsl:attribute name="autobuffer" />
                </xsl:if>
                <xsl:element name="source" namespace="http://www.w3.org/1999/xhtml">
                  <xsl:attribute name="src">
                    <xsl:value-of select="enclosure/@url"/>
                  </xsl:attribute>
                  <xsl:attribute name="type">
                    <xsl:value-of select="enclosure/@type"/>
                  </xsl:attribute>
                </xsl:element>
              </xsl:element>
            </xsl:if>
            <xsl:if test="contains(enclosure/@type, 'audio')">
              <xsl:variable name="encURL" select="enclosure/@url" xmlns:atom="http://www.w3.org/2005/Atom"/>
              <xsl:element name="audio" namespace="http://www.w3.org/1999/xhtml">
                <xsl:attribute name="controls" />
                <xsl:attribute name="preload">none</xsl:attribute>

                <xsl:element name="source" namespace="http://www.w3.org/1999/xhtml">
                  <xsl:attribute name="src">
                    <xsl:value-of select="enclosure/@url"/>
                  </xsl:attribute>
                  <xsl:attribute name="type">
                    <xsl:value-of select="enclosure/@type"/>
                  </xsl:attribute>
                </xsl:element>
              </xsl:element>
            </xsl:if>
          </xsl:if>
          <xsl:element name="p" namespace="http://www.w3.org/1999/xhtml">
            <xsl:attribute name="class">download</xsl:attribute>
            <xsl:element name="a" namespace="http://www.w3.org/1999/xhtml">
              <xsl:attribute name="target">_blank</xsl:attribute>
              <xsl:attribute name="href">
                <xsl:value-of select="enclosure/@url"/>
              </xsl:attribute>
              Ladda ner
            </xsl:element>
          </xsl:element>

        </div>
        <div class="itemcontent" name="decodeable">
          <xsl:call-template name="outputContent"/>
        </div>
      </li>
  </xsl:template>
  <xsl:template match="image">
    <a href="{link}" title="Link to original website" class="profile">
      <xsl:element name="img" namespace="http://www.w3.org/1999/xhtml">
        <xsl:attribute name="src">
          <xsl:value-of select="url"/>
        </xsl:attribute>
        <xsl:attribute name="alt">Link to <xsl:value-of select="title"/></xsl:attribute>
        <xsl:attribute name="class">img-responsive</xsl:attribute>
      </xsl:element>
    </a>
    <xsl:text/>
  </xsl:template>
  <xsl:template name="outputContent">
    <xsl:choose>
      <xsl:when xmlns:xhtml="http://www.w3.org/1999/xhtml" test="xhtml:body">
        <xsl:copy-of select="xhtml:body/*"/>

      </xsl:when>
      <xsl:when xmlns:xhtml="http://www.w3.org/1999/xhtml" test="xhtml:div">
        <xsl:copy-of select="xhtml:div"/>
      </xsl:when>
      <xsl:when xmlns:content="http://purl.org/rss/1.0/modules/content/" test="content:encoded">
        <xsl:value-of select="content:encoded" disable-output-escaping="yes"/>
      </xsl:when>
      <xsl:when test="description">
        <xsl:value-of select="description" disable-output-escaping="yes"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>