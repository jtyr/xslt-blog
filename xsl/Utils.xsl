<?xml version="1.0" encoding="utf-8"?>


<!--
  **********************************************************
  ** Description: Utilites - shared template
  **
  ** (c) Jiri Tyr 2007
  **********************************************************
  -->


<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


<!-- reverse the input string -->
<xsl:template name="reverse">
    <xsl:param name="input"/>
    <xsl:variable name="len" select="string-length($input)"/>

    <xsl:choose>

        <!-- Strings of length less than 2 are trivial to reverse -->
        <xsl:when test="$len &lt; 2">
            <xsl:value-of select="$input"/>
        </xsl:when>

        <!-- Strings of length 2 are also trivial to reverse -->
        <xsl:when test="$len = 2">
            <xsl:value-of select="substring($input,2,1)"/>
            <xsl:value-of select="substring($input,1,1)"/>
        </xsl:when>

        <xsl:otherwise>
            <!-- Swap the recursive application of this template to the first half and second half of input -->
            <xsl:variable name="mid" select="floor($len div 2)"/>

            <xsl:call-template name="reverse">
                <xsl:with-param name="input" select="substring($input,$mid+1,$mid+1)"/>
            </xsl:call-template>

            <xsl:call-template name="reverse">
                <xsl:with-param name="input" select="substring($input,1,$mid)"/>
            </xsl:call-template>
        </xsl:otherwise>

    </xsl:choose>
</xsl:template>


</xsl:transform>
