<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" version="1.0">
  <xsl:output method="html" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"/>
  <xsl:variable name="title" select="/rss/channel/title"/>
  <xsl:variable name="feedDesc" select="/rss/channel/description"/>
  <xsl:variable name="copyright" select="/rss/channel/copyright"/>
  <xsl:variable name="feedUrl" select="/rss/channel/atom:link[@rel='self']/@href" xmlns:atom="http://www.w3.org/2005/Atom"/>

  <xsl:template match="/">
    <xsl:element name="html">
      <head>
        <title><xsl:value-of select="$title"/></title>
        <link href="https://bronoverrattvik.github.io/assets/main.css" rel="stylesheet" type="text/css" media="all"/>
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
            <h2 class="footer-heading"><a href="https://bronoverrattvik.github.io/">Bron över Rättvik</a></h2>
          </div>
        </footer>
      </main>
    </body>
  </xsl:template>

  <xsl:template match="item" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:atom="http://www.w3.org/2005/Atom">
      <li class="post-content">
        <span class="post-meta">
          <xsl:if test="count(child::pubDate)=1">
            <xsl:call-template name="format-from-rfc-to-iso">
              <xsl:with-param name="rfc-date" select="pubDate" />
            </xsl:call-template>
          </xsl:if>
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
	  <xsl:variable name="vendor" select="system-property('xsl:vendor')"/>
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
 		  <xsl:when test="not(contains($vendor, 'Transformiix')) and description">
        <xsl:value-of select="description" disable-output-escaping="yes"/>
      </xsl:when>
      <!--
          Firefox doesn't support disable-output-escaping:
          https://bugzilla.mozilla.org/show_bug.cgi?id=98168
          (Show plaintext description instead)
      -->
		  <xsl:when test="contains($vendor, 'Transformiix') and itunes:summary">
        <xsl:value-of select="itunes:summary"/>
		  </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- https://gist.github.com/bzerangue/862469 -->
  <xsl:template name="format-from-rfc-to-iso">
		<xsl:param name="rfc-date"/>
		<xsl:param name="day-with-zero" select="format-number(substring(substring($rfc-date,6,11),1,2),'00')"/>
		<xsl:param name="month-with-zero">
			<xsl:if test="contains($rfc-date,'Jan')">01</xsl:if>
			<xsl:if test="contains($rfc-date,'Feb')">02</xsl:if>
			<xsl:if test="contains($rfc-date,'Mar')">03</xsl:if>
			<xsl:if test="contains($rfc-date,'Apr')">04</xsl:if>
			<xsl:if test="contains($rfc-date,'May')">05</xsl:if>
			<xsl:if test="contains($rfc-date,'Jun')">06</xsl:if>
			<xsl:if test="contains($rfc-date,'Jul')">07</xsl:if>
			<xsl:if test="contains($rfc-date,'Aug')">08</xsl:if>
			<xsl:if test="contains($rfc-date,'Sep')">09</xsl:if>
			<xsl:if test="contains($rfc-date,'Oct')">10</xsl:if>
			<xsl:if test="contains($rfc-date,'Nov')">11</xsl:if>
			<xsl:if test="contains($rfc-date,'Dec')">12</xsl:if>
		</xsl:param>
		<xsl:param name="year-full" select="format-number(substring(substring($rfc-date,6,11),7,5),'####')"/>
		<xsl:param name="rfc-date-to-iso" select="concat($year-full,'-',$month-with-zero,'-',$day-with-zero)"/>

		<xsl:value-of select="$rfc-date-to-iso"/>
  </xsl:template>
</xsl:stylesheet>
