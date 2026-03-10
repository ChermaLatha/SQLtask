
CREATE DATABASE IMDB;
USE IMDB;
SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = '';
-- TABLE 1 : users
CREATE TABLE users (
    user_id    INT          NOT NULL,
    username   VARCHAR(100) NOT NULL,
    email      VARCHAR(150) NOT NULL,
    password   VARCHAR(255) NOT NULL,
    created_at DATETIME     DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id),
    UNIQUE KEY uq_username (username),
    UNIQUE KEY uq_email    (email)
);

-- TABLE 2 : genre
CREATE TABLE genre (
    genre_id INT         NOT NULL,
    name     VARCHAR(80) NOT NULL,
    PRIMARY KEY (genre_id),
    UNIQUE KEY uq_genre_name (name)
);

-- TABLE 3 : movies
CREATE TABLE movies (
    movie_id      INT          NOT NULL,
    title         VARCHAR(200) NOT NULL,
    release_year  YEAR         NOT NULL,
    duration_mins INT,
    language      VARCHAR(50)  DEFAULT 'Tamil',
    plot          TEXT,
    imdb_rating   DECIMAL(3,1),
    created_at    DATETIME     DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (movie_id)
);

-- TABLE 4 : movie_genre   [REQ 2 - Movie to multiple Genres]
CREATE TABLE movie_genre (
    movie_id INT NOT NULL,
    genre_id INT NOT NULL,
    PRIMARY KEY (movie_id, genre_id),
    CONSTRAINT fk_mg_movie FOREIGN KEY (movie_id) REFERENCES movies (movie_id) ON DELETE CASCADE,
    CONSTRAINT fk_mg_genre FOREIGN KEY (genre_id) REFERENCES genre  (genre_id) ON DELETE CASCADE
);

-- TABLE 5 : media   [REQ 1 - Movie to multiple Media]
CREATE TABLE media (
    media_id    INT                   NOT NULL,
    movie_id    INT                   NOT NULL,
    media_type  ENUM('Video','Image') NOT NULL,
    url         VARCHAR(500)          NOT NULL,
    title       VARCHAR(150),
    uploaded_at DATETIME              DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (media_id),
    CONSTRAINT fk_media_movie FOREIGN KEY (movie_id) REFERENCES movies (movie_id) ON DELETE CASCADE
);


-- TABLE 6 : reviews   [REQ 3 - Movie to multiple Reviews to User]
CREATE TABLE reviews (
    review_id   INT          NOT NULL,
    movie_id    INT          NOT NULL,
    user_id     INT          NOT NULL,
    rating      DECIMAL(3,1),
    review_text TEXT,
    created_at  DATETIME     DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (review_id),
    CONSTRAINT fk_rev_movie FOREIGN KEY (movie_id) REFERENCES movies (movie_id) ON DELETE CASCADE,
    CONSTRAINT fk_rev_user  FOREIGN KEY (user_id)  REFERENCES users  (user_id)  ON DELETE CASCADE
);

-- TABLE 7 : artists
CREATE TABLE artists (
    artist_id   INT          NOT NULL,
    full_name   VARCHAR(150) NOT NULL,
    birth_date  DATE,
    nationality VARCHAR(80)  DEFAULT 'Indian',
    bio         TEXT,
    PRIMARY KEY (artist_id)
);

-- TABLE 8 : skills
CREATE TABLE skills (
    skill_id   INT          NOT NULL,
    skill_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (skill_id),
    UNIQUE KEY uq_skill_name (skill_name)
);

-- TABLE 9 : artist_skill   [REQ 4 - Artist to multiple Skills]
CREATE TABLE artist_skill (
    artist_id INT NOT NULL,
    skill_id  INT NOT NULL,
    PRIMARY KEY (artist_id, skill_id),
    CONSTRAINT fk_as_artist FOREIGN KEY (artist_id) REFERENCES artists (artist_id) ON DELETE CASCADE,
    CONSTRAINT fk_as_skill  FOREIGN KEY (skill_id)  REFERENCES skills  (skill_id)  ON DELETE CASCADE
);

-- TABLE 10 : roles
CREATE TABLE roles (
    role_id   INT          NOT NULL,
    role_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (role_id),
    UNIQUE KEY uq_role_name (role_name)
);

-- TABLE 11 : movie_artist   [REQ 5 - Artist to multiple Roles in one Film]

CREATE TABLE movie_artist (
    movie_artist_id INT          NOT NULL,
    movie_id        INT          NOT NULL,
    artist_id       INT          NOT NULL,
    role_id         INT          NOT NULL,
    character_name  VARCHAR(150),
    PRIMARY KEY (movie_artist_id),
    UNIQUE KEY uq_movie_artist_role (movie_id, artist_id, role_id),
    CONSTRAINT fk_ma_movie  FOREIGN KEY (movie_id)  REFERENCES movies  (movie_id)  ON DELETE CASCADE,
    CONSTRAINT fk_ma_artist FOREIGN KEY (artist_id) REFERENCES artists (artist_id) ON DELETE CASCADE,
    CONSTRAINT fk_ma_role   FOREIGN KEY (role_id)   REFERENCES roles   (role_id)   ON DELETE CASCADE
);

-- users  (7 rows  |  user_id: 1 to 7)
INSERT INTO users (user_id, username, email, password) VALUES
(1, 'rajesh_fan',       'rajesh@gmail.com',   SHA2('raj1234',       256)),
(2, 'vijay_thalapathy', 'vijay@gmail.com',    SHA2('thalapathy',    256)),
(3, 'ajith_thala',      'ajith@gmail.com',    SHA2('thala2024',     256)),
(4, 'nayanthara_fan',   'nayan@gmail.com',    SHA2('ladysuperstar', 256)),
(5, 'suriya_rocks',     'suriya@gmail.com',   SHA2('suriya123',     256)),
(6, 'kamal_admirer',    'kamal@gmail.com',    SHA2('ulaganayagan',  256)),
(7, 'anirudh_beats',    'anirudh@gmail.com',  SHA2('rowdybaby',     256));

-- genre  (9 rows  |  genre_id: 1 to 9)
INSERT INTO genre (genre_id, name) VALUES
(1, 'Action'),
(2, 'Drama'),
(3, 'Thriller'),
(4, 'Comedy'),
(5, 'Romance'),
(6, 'Crime'),
(7, 'Fantasy'),
(8, 'Social'),
(9, 'Historical');

-- movies  (5 rows  |  movie_id: 1 to 5)
INSERT INTO movies (movie_id, title, release_year, duration_mins, language, plot, imdb_rating) VALUES
(1, 'Vikram',   2022, 174, 'Tamil', 'A special agent investigates murders by masked men, pulling retired agent Vikram back into action.', 7.8),
(2, 'Master',   2021, 179, 'Tamil', 'An alcoholic professor faces a ruthless gangster who uses juvenile children as weapons of crime.',   7.7),
(3, 'Jai Bhim', 2021, 164, 'Tamil', 'A brave lawyer fights for justice for a tribal woman whose husband was illegally detained by police.', 8.8),
(4, 'Kaithi',   2019, 145, 'Tamil', 'A released prisoner races to meet his daughter while caught in a life-or-death police mission.',    8.5),
(5, '2.0',      2018, 148, 'Tamil', 'Scientist Vaseegaran reactivates robot Chitti to fight a deadly villain who controls mobile phones.', 5.6);

-- movie_genre  (14 rows  |  REQ 2)
-- Each movie is mapped to 2-3 different genres
INSERT INTO movie_genre (movie_id, genre_id) VALUES
-- Vikram  : Action(1), Crime(6), Thriller(3)
(1, 1), (1, 6), (1, 3),
-- Master  : Action(1), Drama(2), Crime(6)
(2, 1), (2, 2), (2, 6),
-- Jai Bhim: Drama(2), Social(8), Thriller(3)
(3, 2), (3, 8), (3, 3),
-- Kaithi  : Action(1), Thriller(3)
(4, 1), (4, 3),
-- 2.0     : Action(1), Fantasy(7), Drama(2)
(5, 1), (5, 7), (5, 2);

INSERT INTO media (media_id, movie_id, media_type, url, title) VALUES
-- Vikram (5 items)
(1,  1, 'Video', 'https://youtube.com/vikram_trailer',      'Official Trailer'),
(2,  1, 'Video', 'https://youtube.com/vikram_teaser',       'Motion Teaser'),
(3,  1, 'Image', 'https://imdb.com/vikram/poster.jpg',      'Official Poster'),
(4,  1, 'Image', 'https://imdb.com/vikram/still_kamal.jpg', 'Kamal Haasan Still'),
(5,  1, 'Image', 'https://imdb.com/vikram/still_fahadh.jpg','Fahadh Faasil Still'),
-- Master (4 items)
(6,  2, 'Video', 'https://youtube.com/master_trailer',      'Official Trailer'),
(7,  2, 'Video', 'https://youtube.com/master_bgm',          'BGM Promo'),
(8,  2, 'Image', 'https://imdb.com/master/poster.jpg',      'Official Poster'),
(9,  2, 'Image', 'https://imdb.com/master/still_vijay.jpg', 'Vijay Mass Entry Still'),
-- Jai Bhim (4 items)
(10, 3, 'Video', 'https://youtube.com/jaibhim_trailer',     'Official Trailer'),
(11, 3, 'Image', 'https://imdb.com/jaibhim/poster.jpg',     'Official Poster'),
(12, 3, 'Image', 'https://imdb.com/jaibhim/court.jpg',      'Court Scene Still'),
(13, 3, 'Image', 'https://imdb.com/jaibhim/suriya.jpg',     'Suriya Emotional Still'),
-- Kaithi (3 items)
(14, 4, 'Video', 'https://youtube.com/kaithi_trailer',      'Official Trailer'),
(15, 4, 'Video', 'https://youtube.com/kaithi_teaser',       'Teaser'),
(16, 4, 'Image', 'https://imdb.com/kaithi/poster.jpg',      'Official Poster'),
-- 2.0 (4 items)
(17, 5, 'Video', 'https://youtube.com/2point0_trailer',     'Official Trailer'),
(18, 5, 'Video', 'https://youtube.com/2point0_vfx',         'VFX Breakdown Reel'),
(19, 5, 'Image', 'https://imdb.com/2point0/poster.jpg',     'Official Poster'),
(20, 5, 'Image', 'https://imdb.com/2point0/chitti.jpg',     'Chitti Robot Still');

INSERT INTO reviews (review_id, movie_id, user_id, rating, review_text) VALUES
-- Vikram  reviewed by users 1, 2, 3
(1,  1, 1, 9.0,  'Kamal Haasan is back with a bang! Every frame is electric. Lokesh is a genius.'),
(2,  1, 2, 8.5,  'Fahadh Faasil as the villain is absolutely terrifying. Best Tamil film in years.'),
(3,  1, 3, 9.5,  'Interval block had the entire theatre screaming. Rajini cameo was mind-blowing!'),
-- Master  reviewed by users 1, 4, 7
(4,  2, 1, 8.5,  'Vijay mass entry scene is legendary. Vijay Sethupathi outstanding as the villain.'),
(5,  2, 4, 8.0,  'Whistle Podu song is fire. Anirudh killed the BGM as always.'),
(6,  2, 7, 9.0,  'Lokesh direction is tight. The juvenile school setting makes it very unique.'),
-- Jai Bhim reviewed by users 5, 6, 4
(7,  3, 5, 10.0, 'Tears throughout. Suriya gave his career-best performance. Must watch for every Indian.'),
(8,  3, 6, 9.5,  'Based on a real story that shakes you to the core. Powerful, important cinema.'),
(9,  3, 4, 9.0,  'Jai Bhim is not just a film, it is a movement. Suriya as Chandru is unforgettable.'),
-- Kaithi  reviewed by users 2, 7
(10, 4, 2, 9.5,  'Non-stop adrenaline from start to finish. Karthi best film. Zero songs, pure story!'),
(11, 4, 7, 9.0,  'Sam CS BGM hits different in a dark theatre. The climax is absolutely unreal.'),
-- 2.0     reviewed by users 3, 6
(12, 5, 3, 7.5,  'VFX is top class for Indian cinema. Rajinikanth and Akshay Kumar together is a treat.'),
(13, 5, 6, 6.5,  'Visually spectacular but the story could have been stronger.');

-- artists  (11 rows  |  artist_id: 1 to 11)

INSERT INTO artists (artist_id, full_name, birth_date, nationality, bio) VALUES
(1,  'Kamal Haasan',        '1954-11-07', 'Indian', 'Ulaganayagan - legendary actor, director, writer and producer with 60 years in cinema.'),
(2,  'Lokesh Kanagaraj',    '1988-06-15', 'Indian', 'Blockbuster director of Kaithi, Master and Vikram. Creator of the LCU universe.'),
(3,  'Vijay Sethupathi',    '1978-01-16', 'Indian', 'Makkal Selvan - versatile actor who excels in both villain and lead roles.'),
(4,  'Fahadh Faasil',       '1983-08-08', 'Indian', 'National Award-winning actor known for intense and layered performances.'),
(5,  'Suriya',              '1975-07-23', 'Indian', 'Acclaimed actor and producer known for powerful social dramas and entertainers.'),
(6,  'Karthi',              '1977-05-25', 'Indian', 'Dependable actor known for grounded action and rural-based films.'),
(7,  'Rajinikanth',         '1950-12-12', 'Indian', 'Superstar of Indian cinema with iconic style, dialogue and a worldwide fan base.'),
(8,  'Anirudh Ravichander', '1990-10-16', 'Indian', 'Chart-topping music composer and singer; youngest to score multiple superhit albums.'),
(9,  'Sam C.S.',            '1985-03-10', 'Indian', 'BGM specialist known for intense and gripping background score compositions.'),
(10, 'A.R. Rahman',         '1967-01-06', 'Indian', 'Oscar and Grammy Award-winning composer, singer and music producer.'),
(11, 'Thalapathy Vijay',    '1974-06-22', 'Indian', 'Mass entertainer superstar with a massive fan following across South India.');

-- skills  (9 rows  |  skill_id: 1 to 9)
INSERT INTO skills (skill_id, skill_name) VALUES
(1, 'Acting'),
(2, 'Directing'),
(3, 'Screenwriting'),
(4, 'Film Producing'),
(5, 'Music Composing'),
(6, 'Singing'),
(7, 'Stunts'),
(8, 'Dancing'),
(9, 'Dubbing');


INSERT INTO artist_skill (artist_id, skill_id) VALUES
-- 1  Kamal Haasan : Acting(1) Directing(2) Screenwriting(3) Producing(4) Singing(6) Dancing(8) Dubbing(9)
(1, 1), (1, 2), (1, 3), (1, 4), (1, 6), (1, 8), (1, 9),
-- 2  Lokesh Kanagaraj : Directing(2) Screenwriting(3)
(2, 2), (2, 3),
-- 3  Vijay Sethupathi : Acting(1) Producing(4) Singing(6)
(3, 1), (3, 4), (3, 6),
-- 4  Fahadh Faasil : Acting(1)
(4, 1),
-- 5  Suriya : Acting(1) Producing(4) Dubbing(9)
(5, 1), (5, 4), (5, 9),
-- 6  Karthi : Acting(1) Stunts(7)
(6, 1), (6, 7),
-- 7  Rajinikanth : Acting(1) Producing(4) Dancing(8) Dubbing(9)
(7, 1), (7, 4), (7, 8), (7, 9),
-- 8  Anirudh : Music Composing(5) Singing(6)
(8, 5), (8, 6),
-- 9  Sam C.S. : Music Composing(5)
(9, 5),
-- 10 A.R. Rahman : Music Composing(5) Singing(6)
(10, 5), (10, 6),
-- 11 Thalapathy Vijay : Acting(1) Singing(6) Stunts(7) Dancing(8)
(11, 1), (11, 6), (11, 7), (11, 8);


-- roles  (7 rows  |  role_id: 1 to 7)
INSERT INTO roles (role_id, role_name) VALUES
(1, 'Actor'),
(2, 'Director'),
(3, 'Screenwriter'),
(4, 'Producer'),
(5, 'Music Composer'),
(6, 'Supporting Actor'),
(7, 'Cameo');

INSERT INTO movie_artist (movie_artist_id, movie_id, artist_id, role_id, character_name) VALUES

-- VIKRAM (movie_id=1)
(1,  1,  1, 1, 'Vikram'),            -- Kamal Haasan    : Actor
(2,  1,  1, 4, NULL),                -- Kamal Haasan    : Producer       ★ 2 roles same film
(3,  1,  2, 2, NULL),                -- Lokesh Kanagaraj: Director
(4,  1,  2, 3, NULL),                -- Lokesh Kanagaraj: Screenwriter   ★ 2 roles same film
(5,  1,  3, 6, 'Aadhi'),             -- Vijay Sethupathi: Supporting Actor
(6,  1,  4, 6, 'Santhanam'),         -- Fahadh Faasil   : Supporting Actor
(7,  1,  7, 7, 'Rolex'),             -- Rajinikanth     : Cameo
(8,  1,  8, 5, NULL),                -- Anirudh         : Music Composer

-- MASTER (movie_id=2)
(9,  2, 11, 1, 'JD'),                -- Thalapathy Vijay: Actor
(10, 2,  3, 1, 'Bhavani'),           -- Vijay Sethupathi: Actor
(11, 2,  2, 2, NULL),                -- Lokesh Kanagaraj: Director
(12, 2,  2, 3, NULL),                -- Lokesh Kanagaraj: Screenwriter    2 roles same film
(13, 2,  8, 5, NULL),                -- Anirudh         : Music Composer

-- JAI BHIM (movie_id=3)
(14, 3,  5, 1, 'Chandru'),           -- Suriya          : Actor
(15, 3,  5, 4, NULL),                -- Suriya          : Producer         2 roles same film
(16, 3,  9, 5, NULL),                -- Sam C.S.        : Music Composer

-- KAITHI (movie_id=4)
(17, 4,  6, 1, 'Dilli'),             -- Karthi          : Actor
(18, 4,  2, 2, NULL),                -- Lokesh Kanagaraj: Director
(19, 4,  2, 3, NULL),                -- Lokesh Kanagaraj: Screenwriter    2 roles same film
(20, 4,  9, 5, NULL),                -- Sam C.S.        : Music Composer

-- 2.0 (movie_id=5)
(21, 5,  7, 1, 'Chitti/Vaseegaran'), -- Rajinikanth     : Actor
(22, 5,  7, 4, NULL),                -- Rajinikanth     : Producer         2 roles same film
(23, 5, 10, 5, NULL);                -- A.R. Rahman     : Music Composer

SET FOREIGN_KEY_CHECKS = 1;
-- REQ 1 : Multiple Media per Movie
SELECT m.title, md.media_type, md.url
FROM movies m
JOIN media md
ON m.movie_id = md.movie_id;

-- REQ 2 : Multiple Genres per Movie
SELECT m.title, g.name
FROM movies m
JOIN movie_genre mg
ON m.movie_id = mg.movie_id
JOIN genre g
ON mg.genre_id = g.genre_id;

-- REQ 3 : Multiple Reviews per Movie with User details
SELECT m.title, u.username, r.rating, r.review_text
FROM reviews r
JOIN movies m
ON r.movie_id = m.movie_id
JOIN users u
ON r.user_id = u.user_id;

-- REQ 4 : Multiple Skills per Artist
SELECT a.full_name, s.skill_name
FROM artists a
JOIN artist_skill ask
ON a.artist_id = ask.artist_id
JOIN skills s
ON ask.skill_id = s.skill_id;

-- REQ 5 : Artists with Multiple Roles in a Single Film
SELECT m.title, a.full_name, r.role_name
FROM movie_artist ma
JOIN movies m
ON ma.movie_id = m.movie_id
JOIN artists a
ON ma.artist_id = a.artist_id
JOIN roles r
ON ma.role_id = r.role_id;
