<?xml version="1.0" encoding="utf-8"?>


<!--
  **********************************************************
  ** Description: HTML pieces - shared template
  **
  ** (c) Jiri Tyr 2007
  **********************************************************
  -->


<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


<!-- HTML header -->
<xsl:template name="getHeader">
	<!-- input params -->
	<xsl:param name="html"/>
	<xsl:param name="date"/>
	<xsl:param name="article"/>

	<div id="Header">
		<xsl:if test="$show_lang_list">
			<div class="Lang">
				<xsl:call-template name="getLangList">
					<xsl:with-param name="html" select="$html"/>
					<xsl:with-param name="param_name">
						<xsl:choose>
							<xsl:when test="string-length($date) > 0">
								<xsl:value-of select="'date'"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'category'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="param_value">
						<xsl:choose>
							<xsl:when test="string-length($date) > 0">
								<xsl:value-of select="$date"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$category"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="article">
						<xsl:if test="string-length($article) > 0">
							<xsl:value-of select="$article"/>
						</xsl:if>
					</xsl:with-param>
				</xsl:call-template>
			</div>
		</xsl:if>
		<div class="BlogName"><a href="index.html"><xsl:value-of select="$blog_name"/></a></div>
		<br class="Clear"/>
		<span class="Clear"/>
	</div>
</xsl:template>


<!-- HTML footer -->
<xsl:template name="getFooter">
	<div id="Footer">
		<div class="Powered"><xsl:call-template name="getText"><xsl:with-param name="id" select="'powered_by'"/></xsl:call-template><a href="http://xslt-blog.sourceforge.net" rel="external">XSLT-Blog</a></div>
		<div class="Version"><xsl:call-template name="getText"><xsl:with-param name="id" select="'version'"/></xsl:call-template><xsl:value-of select="$version"/></div>
		<br class="Clear"/>
	</div>
</xsl:template>


</xsl:transform>
