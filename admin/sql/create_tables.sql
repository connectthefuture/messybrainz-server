BEGIN;

CREATE TABLE recording (
  id         SERIAL,
  gid        UUID    NOT NULL,
  data       INTEGER NOT NULL, -- FK to recording_json.id
  artist     UUID    NOT NULL, -- FK to artist.gid
  release    UUID,             -- FK to release.gid
  submitted  TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE recording_json (
  id          SERIAL,
  data        JSON     NOT NULL,
  data_sha256 CHAR(64) NOT NULL,
  meta_sha256 CHAR(64) NOT NULL
);

-- Messybrainz artists are artist credits. That is, they could
-- represent more than 1 musicbrainz id. These are linked in the
-- artist_redirect table.
CREATE TABLE artist_credit (
  gid  UUID NOT NULL,
  name TEXT NOT NULL,
  submitted  TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE release (
  gid   UUID NOT NULL,
  title TEXT NOT NULL,
  submitted  TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE recording_redirect (
  recording_cluster_id UUID NOT NULL,
  recording_mbid       UUID NOT NULL
);

CREATE TABLE recording_cluster (
  cluster_id    UUID NOT NULL,
  recording_gid UUID NOT NULL, -- FK to recording.gid, Unique
  updated       TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE artist_credit_redirect (
  artist_credit_cluster_id UUID NOT NULL, -- FK to artist_credit_cluster.cluster_id
  artist_mbid              UUID NOT NULL
);

CREATE TABLE artist_credit_cluster (
  cluster_id        UUID,
  artist_credit_gid UUID, -- FK to artist_credit.gid, Not unique
  updated           TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE release_redirect (
  release_cluster_id UUID NOT NULL, --FK to release_cluster.cluster_id
  release_mbid       UUID NOT NULL
);

CREATE TABLE release_cluster (
  cluster_id  UUID,
  release_gid UUID, -- FK to release.gid, Unique
  updated     TIMESTAMP WITH TIME ZONE NOT NULL
);

COMMIT;
