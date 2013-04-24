<?xml version="1.0" encoding="utf-8"?>


<!--
  **********************************************************
  ** Description: Article template
  **
  ** (c) Jiri Tyr 2007
  **********************************************************
  -->


<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


<!-- includes -->
<xsl:include href="Setting.xsl"/>
<xsl:include href="Lang.xsl"/>
<xsl:include href="Category.xsl"/>
<xsl:include href="Utils.xsl"/>
<xsl:include href="HTMLPieces.xsl"/>


<!-- global params -->
<xsl:param name="article"/>
<xsl:param name="date"/>


<!-- root element -->
<xsl:template match="/">
	<xsl:call-template name="getHeader">
		<xsl:with-param name="html" select="'article'"/>
		<xsl:with-param name="date" select="$date"/>
		<xsl:with-param name="article" select="$article"/>
	</xsl:call-template>

	<!-- menu -->
	<div id="MenuPanel">
		<div class="Menu">
			<div class="Title"><xsl:call-template name="getText"><xsl:with-param name="id" select="'navigation'"/></xsl:call-template></div>
			<div class="Body">
				<ul>
					<xsl:choose>
						<xsl:when test="string-length($date) > 0">
							<li><a href="index.html?page={$page}&amp;date={$date}"><xsl:call-template name="getText"><xsl:with-param name="id" select="'navigation_back'"/></xsl:call-template></a></li>
						</xsl:when>
						<xsl:otherwise>
							<li><a href="index.html?page={$page}&amp;category={$category}"><xsl:call-template name="getText"><xsl:with-param name="id" select="'navigation_back'"/></xsl:call-template></a></li>
						</xsl:otherwise>
					</xsl:choose>
				</ul>
			</div>
		</div>
	</div>

	<xsl:choose>
		<xsl:when test="/article/title">
			<div id="ArticleContent">
				<!-- article name -->
				<h2><xsl:value-of select="/article/title"/></h2>

				<!-- article infos -->
		    		<div class="Info">
		    			<b><xsl:call-template name="getText"><xsl:with-param name="id" select="'list_info_date'"/></xsl:call-template></b><xsl:value-of select="document('../xml/ArticleList.xml')/article_list/a[@i=$article]/@d"/>

					<xsl:variable name="data" select="document('../xml/ArticleList.xml')/article_list/a[@i=$article]/c"/>

					<xsl:if test="count($data) > 0">
						<xsl:text>, </xsl:text><b><xsl:call-template name="getText"><xsl:with-param name="id" select="'list_info_category'"/></xsl:call-template></b>

						<xsl:call-template name="getCategoryNames">
							<xsl:with-param name="data" select="$data"/>
						</xsl:call-template>
					</xsl:if>

					<xsl:if test="$show_lang_flag and /article[@lang] and /article/@lang != $lang">
						<xsl:variable name="l" select="/article/@lang"/>
						<xsl:variable name="flag" select="document('../xml/LangList.xml')/lang_list/lang[@id=$l]/@flag"/>
						<xsl:text>, </xsl:text><b><xsl:call-template name="getText"><xsl:with-param name="id" select="'list_article_lang'"/></xsl:call-template></b><img src="./design/flags/flag_{$flag}.png" width="21" height="14" alt="flag" style="vertical-align: bottom;"/>
					</xsl:if>
				</div>

				<!-- article body -->
				<div class="Text">
					<xsl:copy-of select="/article/text"/>
				</div>
			</div>
		</xsl:when>
		<xsl:otherwise>
			<div class="Center Bold"><xsl:call-template name="getText"><xsl:with-param name="id" select="'wrong_article'"/></xsl:call-template></div>
		</xsl:otherwise>
	</xsl:choose>

	<!-- print header -->
	<xsl:call-template name="getFooter"/>

	<script type="text/javascript">
		document.title = "<xsl:value-of select="$blog_name"/> - <xsl:value-of select="/article/title"/>";
	</script>
</xsl:template>


</xsl:transform>
