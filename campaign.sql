SELECT campaign_id, impressions AS totalImpressions
FROM campaigndata
GROUP BY campaign_id;

SELECT campaign_id, company, roi
FROM campaigndata
ORDER BY roi DESC
LIMIT 1;

SELECT location,
	SUM(impressions) AS totalImpressions
FROM campaigndata
GROUP BY location
ORDER BY totalImpressions DESC
LIMIT 3;

SELECT target_audience,
	AVG(engagement_score::NUMERIC) AS avgengagementscore
FROM campaigndata
GROUP BY target_audience
ORDER BY avgengagementscore DESC;

SELECT ((SUM(clicks)::NUMERIC)/SUM(impressions) * 100.0) as overallctr
FROM campaigndata;

SELECT campaign_id, company,
		ROUND((acquisition_cost::NUMERIC/NULLIF((conversion_rate * clicks), 0)), 2) AS costperconversion
FROM campaigndata
ORDER BY costperconversion ASC
LIMIT 1;

WITH CampaignCTR AS (
    SELECT campaign_id, 
           company,
           ROUND(((NULLIF(clicks::NUMERIC, 0) /NULLIF(impressions,0)) * 100),2) AS ctr
    FROM campaigndata
)
SELECT campaign_id, company, ctr
FROM CampaignCTR
WHERE ctr > 5
ORDER BY ctr DESC;
WITH CHannelConversions AS (
	SELECT channel_used,
			SUM(conversion_rate * clicks) AS totalconversions
	FROM campaigndata
	GROUP BY channel_used
)
SELECT channel_used,
	totalconversions
FROM ChannelConversions
ORDER BY totalconversions DESC;