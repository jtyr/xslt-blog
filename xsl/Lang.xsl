<?xml version="1.0" encoding="utf-8"?>


<!--
  **********************************************************
  ** Description: Language list template - shared template
  **
  ** (c) Jiri Tyr 2007
  **********************************************************
  -->


<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


<!-- get list of all languages -->
<xsl:template name="getLangList">
	<!-- input params -->
	<xsl:param name="html"/>
	<xsl:param name="param_name"/>
	<xsl:param name="param_value"/>
	<xsl:param name="article"/>

	<ul>
		<xsl:for-each select="document('../xml/LangList.xml')//lang">
			<xsl:choose>
				<xsl:when test="@id = $lang">
					<xsl:choose>
						<xsl:when test="$html = 'article'">
							<li class="Bold"><xsl:if test="position() != 1"><span><xsl:call-template name="getText"><xsl:with-param name="id" select="'lang_separator'"/></xsl:call-template></span></xsl:if><a href="{$html}.html?lang={@id}&amp;article={$article}&amp;page={$page}&amp;{$param_name}={$param_value}"><xsl:value-of select="@name"/></a></li>
		    				</xsl:when>
						<xsl:otherwise>
							<li class="Bold"><xsl:if test="position() != 1"><span><xsl:call-template name="getText"><xsl:with-param name="id" select="'lang_separator'"/></xsl:call-template></span></xsl:if><a href="{$html}.html?lang={@id}&amp;page={$page}&amp;{$param_name}={$param_value}"><xsl:value-of select="@name"/></a></li>
						</xsl:otherwise>
					</xsl:choose>
    				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$html = 'article'">
							<li><xsl:if test="position() != 1"> <xsl:call-template name="getText"><xsl:with-param name="id" select="'lang_separator'"/></xsl:call-template> </xsl:if><a href="{$html}.html?lang={@id}&amp;article={$article}&amp;page={$page}&amp;{$param_name}={$param_value}"><xsl:value-of select="@name"/></a></li>
		    				</xsl:when>
						<xsl:otherwise>
							<li><xsl:if test="position() != 1"> <xsl:call-template name="getText"><xsl:with-param name="id" select="'lang_separator'"/></xsl:call-template> </xsl:if><a href="{$html}.html?lang={@id}&amp;page={$page}&amp;{$param_name}={$param_value}"><xsl:value-of select="@name"/></a></li>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</ul>
</xsl:template>


<!-- return text string -->
<xsl:template name="getText">
	<xsl:param name="id"/>

	<xsl:value-of select="document(concat('../xml/lang/Lang-', $lang, '.xml'))//text[@id=$id]"/>
</xsl:template>


</xsl:transform>
