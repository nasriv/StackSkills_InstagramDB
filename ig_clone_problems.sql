use ig_clone;

-- Find the 5 oldest IG users ---------
SELECT 
    *
FROM
    users
ORDER BY created_at
LIMIT 5;

-- What day of the week do most users register? ----------
SELECT 
    COUNT(username) AS total, DAYNAME(created_at) AS day
FROM
    users
GROUP BY day
ORDER BY total DESC;

-- find users who have never posted a photo --------------
SELECT 
    username, IFNULL(image_url, 'Inactive') AS Status
FROM
    users
        LEFT JOIN
    photos ON users.id = photos.user_id
WHERE
    photos.id IS NULL;
    
-- find user who posted the most liked photo and the photo url? ------------
SELECT 
    username, image_url, COUNT(*)
FROM
    photos
        JOIN
    likes ON photos.id = likes.photo_id
		join 
	users on users.id = photos.user_id
GROUP BY photos.id
ORDER BY COUNT(*) DESC
limit 1;

-- how many times does the average user post? -------------
SELECT 
    (SELECT COUNT(*) FROM photos) / 
	(SELECT COUNT(*) FROM users) as avg_post_per_user;

-- what are the top 5 most commonly used hashtags? ------
SELECT 
    tags.tag_name, COUNT(*) as total
FROM
    tags
        JOIN
    photo_tags ON photo_tags.tag_id = tags.id
GROUP BY tag_name
ORDER BY total DESC
LIMIT 5;

-- (potential bots), find users who have liked every single photo on the site ------
SELECT 
    username, count(*) as num_likes
FROM
    users
        INNER JOIN
    likes ON likes.user_id = users.id
GROUP BY users.id
having num_likes = (select count(*) from photos);