-- =====================================================================
-- invalid.sql: prova que as restrições funcionam
-- Primeiro inserimos dados VÁLIDOS (para que os erros que se seguem
-- sejam só pelo motivo que queremos testar). Depois fazemos 5 INSERT
-- que TÊM de falhar. Corre SEM ON_ERROR_STOP para veres os 5 erros.
-- =====================================================================


-- ---------------------------------------------------------------------
-- Dados de apoio (todos válidos, não devem dar erro)
-- Os ids são gerados por ordem: o primeiro de cada tabela fica com 1.
-- É por isso que abaixo se usa "1" nas referências.
-- ---------------------------------------------------------------------
INSERT INTO publisher (name) VALUES ('Porto Editora');               -- publisher_id = 1

-- NOTA: dígito de controlo corrigido (…002). Com text, o …001 passava,
-- mas falharia se mais tarde usares o domínio isbn13 do desafio.
INSERT INTO book (isbn, title, publisher_id)
VALUES ('9789720000002', 'Livro A', 1);                              -- book_id = 1

INSERT INTO reader (name, email, tax_number)
VALUES ('Ana', 'ana@example.com', '123456789');                      -- reader_id = 1

INSERT INTO copy (barcode, book_id) VALUES ('C-001', 1);             -- copy_id = 1

-- loan_date usa o DEFAULT (hoje); due_date = hoje + 14 dias
INSERT INTO loan (reader_id, copy_id, due_date)
VALUES (1, 1, current_date + 14);                                    -- loan_id = 1


-- ---------------------------------------------------------------------
-- 1. Viola due_after_loan (CHECK)
--    O prazo (2026-10-01) é anterior ao empréstimo (2026-10-26).
--    A condição due_date > loan_date dá falso, por isso a linha é recusada.
-- ---------------------------------------------------------------------
INSERT INTO loan (reader_id, copy_id, loan_date, due_date)
VALUES (1, 1, '2026-10-26', '2026-10-01');

-- ---------------------------------------------------------------------
-- 2. Viola reader_email_key (UNIQUE)
--    O email 'ana@example.com' já existe na linha da Ana.
--    (O NIF é diferente, por isso o único problema é o email.)
-- ---------------------------------------------------------------------
INSERT INTO reader (name, email, tax_number)
VALUES ('Ana 2', 'ana@example.com', '987654321');

-- ---------------------------------------------------------------------
-- 3. Viola loan_reader_id_fkey (FOREIGN KEY)
--    O leitor 999 não existe na tabela reader.
-- ---------------------------------------------------------------------
INSERT INTO loan (reader_id, copy_id, due_date)
VALUES (999, 1, current_date + 14);

-- ---------------------------------------------------------------------
-- 4. Viola valid_status (CHECK)
--    'lost' não está na lista ('pending', 'fulfilled', 'cancelled').
-- ---------------------------------------------------------------------
INSERT INTO reservation (reader_id, book_id, status)
VALUES (1, 1, 'lost');

-- ---------------------------------------------------------------------
-- 5. Viola amount_positive (CHECK)
--    O valor -5.00 não cumpre amount > 0. O empréstimo 1 existe,
--    por isso a FK está correta e só o CHECK falha.
-- ---------------------------------------------------------------------
INSERT INTO fine (loan_id, amount) VALUES (1, -5.00);