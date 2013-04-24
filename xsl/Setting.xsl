<?xml version="1.0" encoding="utf-8"?>


<!--
  **********************************************************
  ** Description: XSLT-Blog setting - shared template
  **
  ** (c) Jiri Tyr 2007-2008
  **********************************************************
  -->


<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


<!-- default enviroment language -->
<xsl:param name="lang" select="'en'"/>
<!-- default calendar language -->
<xsl:param name="calendar_lang" select="'en'"/>
<!-- show the language list -->
<xsl:param name="show_lang_list" select="1"/>
<!-- show the language flag -->
<xsl:param name="show_lang_flag" select="1"/>
<!-- show count of articles in categories -->
<xsl:param name="show_article_count" select="1"/>
<!-- sort categories in the menu by its name -->
<xsl:param name="sort_categories" select="1"/>

<!-- the list begin at page -->
<xsl:param name="page" select="1"/>
<!-- list only this category; empty=all -->
<xsl:param name="category" select="0"/>
<!-- number of articles what will be displayed at this page -->
<xsl:param name="count" select="5"/>
<!-- maximum length of the visible text on main page -->
<xsl:param name="max_length" select="500"/>

<!-- version number -->
<xsl:param name="version" select="'0.2.3'"/>

<!-- blog name -->
<xsl:param name="blog_name" select="&quot;Jiri Tyr's blog&quot;"/>


</xsl:transform>
