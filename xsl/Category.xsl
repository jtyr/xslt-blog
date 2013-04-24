<?xml version="1.0" encoding="utf-8"?>


<!--
  **********************************************************
  ** Description: Category - shared template
  **
  ** (c) Jiri Tyr 2007
  **********************************************************
  -->


<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


<!-- return list of names of categories -->
<xsl:template name="getCategoryNames">
	<!-- input parameter -->
	<xsl:param name="data"/>

	<!-- number of names in category -->
	<xsl:variable name="name_count" select="count($data)"/>

	<!-- print all category names -->
	<xsl:for-each select="$data">
		<xsl:variable name="cur_id" select="./@i"/>

		<xsl:for-each select="document('../xml/CategoryList.xml')//category">
			<xsl:if test="$cur_id = ./@id and $cur_id != 0">
				<a href="index.html?category={./@id}"><xsl:value-of select="./@name"/></a>
			</xsl:if>
		</xsl:for-each>

		<!-- if more names, print "," -->
		<xsl:if test="position() &lt; $name_count and $cur_id != 0">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:for-each>
</xsl:template>


<!-- print structured category list -->
<xsl:template name="getCategoryTree">
	<!-- input param -->
	<xsl:param name="cat"/>

	<ul>

	<xsl:for-each select="$cat">
		<!--<xsl:sort select="./@name"/>-->

		<xsl:variable name="id" select="./@id"/>
		<xsl:variable name="num" select="count(document('../xml/ArticleList.xml')/article_list/a[c[@i=$id]])"/>

		<xsl:variable name="selected">
			<xsl:if test="./@id = $category">
				<xsl:value-of select="'Selected'"/>
			</xsl:if>
		</xsl:variable>

		<li class="{$selected}">
			<a href="index.html?category={$id}"><xsl:value-of select="./@name"/></a>
			<xsl:if test="$show_article_count and $num > 0">
		    		<xsl:text> </xsl:text><span>(<xsl:value-of select="count(document('../xml/ArticleList.xml')/article_list/a[c[@i=$id]])"/>)</span>
			</xsl:if>
		</li>

		<!-- go deeper -->
		<xsl:if test="./child::*">
  			<xsl:call-template name="getCategoryTree">
				<xsl:with-param name="cat" select="./child::*"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:for-each>

	</ul>
</xsl:template>


<!-- get list of subcategories as a string -->
<xsl:template name="getCategoryString">
	<!-- input param -->
	<xsl:param name="cat"/>

	<xsl:for-each select="$cat">
		<xsl:value-of select="concat(' ', @id, ' ')"/>

		<!-- go deeper -->
		<xsl:if test="./child::*">
  			<xsl:call-template name="getCategoryString">
				<xsl:with-param name="cat" select="./child::*"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:for-each>
</xsl:template>


</xsl:transform>
