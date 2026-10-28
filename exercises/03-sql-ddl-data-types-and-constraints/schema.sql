CREATE TABLE publisher (
    publisher_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name         text NOT NULL UNIQUE
);

CREATE TABLE author (
    author_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name      text NOT NULL
);

CREATE TABLE book (
    book_id      integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    isbn         text NOT NULL UNIQUE,
    title        text NOT NULL,
    publisher_id integer NOT NULL REFERENCES publisher ON DELETE RESTRICT
);

CREATE TABLE book_author (

    book_id   integer NOT NULL REFERENCES book ON DELETE CASCADE,
    author_id integer NOT NULL REFERENCES author ON DELETE RESTRICT,
    PRIMARY KEY (book_id, author_id)
);

CREATE TABLE copy (
    copy_id  integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    barcode  text NOT NULL UNIQUE,
    book_id  integer NOT NULL REFERENCES book ON DELETE RESTRICT
);

CREATE TABLE reader (
    reader_id  integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name       text NOT NULL,
    email      text NOT NULL UNIQUE,
    tax_number text NOT NULL UNIQUE,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE loan (
    loan_id     integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    reader_id   integer NOT NULL REFERENCES reader ON DELETE RESTRICT,
    copy_id     integer NOT NULL REFERENCES copy ON DELETE RESTRICT,
    loan_date   date NOT NULL DEFAULT current_date,
    due_date    date NOT NULL,
    return_date date,
    CONSTRAINT due_after_loan CHECK (due_date > loan_date),
    CONSTRAINT return_not_before_loan CHECK (return_date IS NULL OR return_date >= loan_date)
);

CREATE TABLE reservation (
    reservation_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    reader_id      integer NOT NULL REFERENCES reader ON DELETE RESTRICT,
    book_id        integer NOT NULL REFERENCES book ON DELETE RESTRICT,
    reserved_at    timestamptz NOT NULL DEFAULT now(),
    status         text NOT NULL DEFAULT 'pending',
    CONSTRAINT valid_status CHECK (status IN ('pending', 'fulfilled', 'cancelled')),
    CONSTRAINT one_reservation_per_moment UNIQUE (reader_id, book_id, reserved_at)
);

CREATE TABLE fine (
    fine_id   integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    loan_id   integer NOT NULL UNIQUE REFERENCES loan ON DELETE CASCADE,
    amount    numeric(8,2) NOT NULL,
    issued_at date NOT NULL DEFAULT current_date,
    paid_at   date,
    CONSTRAINT amount_positive CHECK (amount > 0)
);