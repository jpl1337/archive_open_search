namespace :import do
    desc "Ingest documents from csv with title,source_url"
    task ingest_csv: :environment do

        csv_path = Rails.root.join("jfk_release_2025.csv")

        puts "Starting import from #{csv_path}"
        total_files = File.foreach(csv_path).count

        unless File.exist?(csv_path)
            puts "File not found #{csv_path}"
            exit(1)
        end
        count = 0

        CSV.foreach(csv_path, headers: true) do |row|
            begin
                doc = Document.find_or_initialize_by(source_url: row["source_url"])
                doc.title = row["title"]
                doc.status = "pending"

                if doc.save
                    count += 1
                    puts "Imported #{doc.title}"

                    # Kick off background processing
                    DownloadAndSplitJob.perform_later(doc.id)
                else
                    puts "Failed to save  #{doc.title}:  #{doc.errors.full_messages.join(',')}"
                end
                # To make sure we're abiding by the robots.txt
                sleep(10)

            rescue => e
                puts "Error processing row #{row.inspection}: #{e.message}"
            end
        end

        puts "Finished importing! Total documents imported: #{count}/#{total_files}"
    end
end